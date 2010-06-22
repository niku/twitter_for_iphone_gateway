require 'appengine-rack'
AppEngine::Rack.configure_app(
    :application => 'twifig',
    :precompilation_enabled => true,
    :version => '1')
require 'twifig'
run Sinatra::Application
