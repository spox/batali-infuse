$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'batali-infuse/version'
Gem::Specification.new do |s|
  s.name = 'batali-infuse'
  s.version = BataliInfuse::VERSION.version
  s.summary = 'Batali infusion'
  s.author = 'Chris Roberts'
  s.email = 'code@chrisroberts.org'
  s.homepage = 'https://github.com/hw-labs/batali-infuse'
  s.description = 'Infuse the Batali resolver into Chef client'
  s.require_path = 'lib'
  s.license = 'Apache 2.0'
  s.add_runtime_dependency 'batali', '>= 0.2.11', '< 1.0.0'
  s.add_runtime_dependency 'chef', '~> 12.2'
  s.files = Dir['{lib}/**/**/*'] + %w(batali-infuse.gemspec README.md CHANGELOG.md LICENSE)
end
