$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
Gem::Specification.new do |s|
  s.name = 'batali-wedge'
  s.version = '0.1.2'
  s.summary = 'Magic wedger'
  s.author = 'Chris Roberts'
  s.email = 'code@chrisroberts.org'
  s.homepage = 'https://github.com/hw-labs/batali-infuse'
  s.description = 'Wedge magic into Chef'
  s.license = 'Apache 2.0'
  s.add_runtime_dependency 'batali-infuse', '> 0'
  s.files = %w(batali-wedge.gemspec)
end
