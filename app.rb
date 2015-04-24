#!/usr/bin/env ruby

require "zen-grids"
require "rack/timeout"
require "sinatra"
require "sinatra/base"
require "sinatra/flash"
require "sinatra/redirect_with_flash"
require "haml"
require "sass"

require_relative "environment"
require_relative "routes"
require_relative "helpers"

configure do
  register Sinatra::Flash
  helpers Sinatra::RedirectWithFlash

  use Rack::MethodOverride
  use Rack::Session::Cookie, secret: Checklist.conf.session_secret
  use Rack::Timeout
  Rack::Timeout.timeout = 9_000_000

  Compass.add_project_configuration(File.join(File.dirname(__FILE__),
                                              "config",
                                              "compass.config"))
  set :scss, Compass.sass_engine_options
end
