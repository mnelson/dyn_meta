$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'rubygems'
require 'rails/all'
require 'dyn_meta'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

I18n.backend.send(:load_file, File.join(File.dirname(__FILE__), 'en.yml'))

RSpec.configure do |config|
  
end
