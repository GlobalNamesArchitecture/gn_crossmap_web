ENV['RACK_ENV'] || "development"
require './app.rb'

set :run, false

use ActiveRecord::ConnectionAdapters::ConnectionManagement

run Sinatra::Application
