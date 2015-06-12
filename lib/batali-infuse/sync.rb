require 'batali-infuse'

class Chef::PolicyBuilder::ExpandNodeObject

  # Provide override to force Batali resolution
  def sync_cookbooks
    Chef::Log.debug("Synchronizing cookbooks")

    begin
      events.cookbook_resolution_start(@expanded_run_list_with_versions)
      cookbook_hash = batali_cookbook_hash

    rescue Exception => e
      # TODO: wrap/munge exception to provide helpful error output
      events.cookbook_resolution_failed(@expanded_run_list_with_versions, e)
      raise
    else
      events.cookbook_resolution_complete(cookbook_hash)
    end

    synchronizer = Chef::CookbookSynchronizer.new(cookbook_hash, events)
    if temporary_policy?
      synchronizer.remove_obsoleted_files = false
    end
    synchronizer.sync_cookbooks

    # register the file cache path in the cookbook path so that CookbookLoader actually picks up the synced cookbooks
    Chef::Config[:cookbook_path] = File.join(Chef::Config[:file_cache_path], "cookbooks")

    cookbook_hash

  end

  # Generate expected cookbook version hash
  #
  # @return [Hash]
  def batali_cookbook_hash
    Chef::Log.warn 'Resolving cookbooks via Batali!'
    system = batali_build_system
    constraints = Smash[
      api_service.get_rest("environments/#{node.chef_environment}").cookbook_versions.to_a
    ]
    restrictions = api_service.get_rest("environments/#{node.chef_environment}").cookbook_versions.to_a
    requirements = Array.new.tap do |reqs|
      @expanded_run_list_with_versions.each do |item|
        c_name, c_version = item.split('@')
        c_name = c_name.split('::').first
        reqs << [c_name, c_version ? c_version : '> 0']
      end
    end
    unless(requirements.empty?)
      solver = Grimoire::Solver.new(
        :requirements => Grimoire::RequirementList.new(
          :name => 'requirements',
          :requirements => requirements
        ),
        :restrictions => Grimoire::RequirementList.new(
          :name => 'restrictions',
          :requirements => restrictions
        ),
        :system => system,
        :score_keeper => batali_build_score_keeper
      )
      results = solver.generate!
      solution = results.pop
      solution_output = solution.units.sort_by(&:name).map{|u| "#{u.name}<#{u.version}>"}.join(', ')
      node.set[:batali] ||= Mash.new
      node.set[:batali][:last_resolution] = Mash[solution.units.map{|u| [u.name, u.version]}]
      Chef::Log.warn "Batali cookbook resolution: #{solution_output}"
      Hash[
        solution.units.map do |unit|
          [unit.name, api_service.get_rest("cookbooks/#{unit.name}/#{unit.version}")]
        end
      ]
    else
      node.set[:batali][:last_resolution] = Mash.new
      Chef::Log.warn 'Batali resolution not required. No cookbooks in run list!'
      Hash.new
    end
  end

  # Build the base system for generating solution
  #
  # @return [Grimoire::System]
  def batali_build_system
    system = Grimoire::System.new
    units = api_service.get_rest('cookbooks?num_versions=all').map do |c_name, meta|
      meta['versions'].map do |info|
        "#{c_name}/#{info['version']}"
      end
    end.flatten.map do |ckbk|
      Batali::Unit.new(
        Smash.new(
          :name => ckbk.split('/').first,
          :version => ckbk.split('/').last,
          :dependencies => api_service.get_rest("cookbooks/#{ckbk}").metadata.dependencies.to_a
        )
      )
    end
    system.add_unit(*units)
    system
  end

  # Build score keeper if it is enabled via settings
  #
  # @return [Batali::ScoreKeeper]
  def batali_build_score_keeper
    if(batali_least_impact?)
      Chef::Log.warn "Batali 'least impact resolution' is currently enabled!"
      if(node[:batali] && node[:batali][:last_resolution])
        Batali::ScoreKeeper.new(
          :manifest => Batali::Manifest.new(
            :cookbooks => node[:batali][:last_resolution].map{ |c_name, c_version|
              Batali::Unit.new(
                :name => c_name,
                :version => c_version
              )
            }
          )
        )
      end
    end
  end

  # @return [TrueClass, FalseClass]
  def batali_least_impact?
    Chef::Config[:batali_least_impact] ||
      (node[:batali] && node[:batali][:least_impact])
  end

end
