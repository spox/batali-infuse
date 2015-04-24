$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'batali-wedge/version'
Gem::Specification.new do |s|
  s.name = 'batali-wedge'
  s.version = BataliWedge::VERSION.version
  s.summary = 'Magic wedger'
  s.author = 'Chris Roberts'
  s.email = 'code@chrisroberts.org'
  s.homepage = 'https://github.com/hw-labs/batali-wedge'
  s.description = 'Wedge magic into Chef'
  s.require_path = 'lib'
  s.license = 'Apache 2.0'
  s.add_runtime_dependency 'batali'
  s.add_runtime_dependency 'chef', '~> 12.2.0'
  s.files = Dir['{lib}/**/**/*'] + %w(batali-wedge.gemspec README.md CHANGELOG.md LICENSE)
end
