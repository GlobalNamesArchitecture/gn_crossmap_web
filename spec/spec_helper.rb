require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "rack/test"
require "capybara"
require "capybara/rspec"
require "capybara/dsl"
require "capybara/webkit"
require "byebug"
require "factory_girl"
require_relative "support/helpers"
require_relative "factories"

ENV["RACK_ENV"] = "test"
require_relative "../app.rb"

Capybara.javascript_driver = :webkit
Capybara.app = Sinatra::Application

RSpec.configure do |c|
  c.include Capybara::DSL
  c.include FactoryGirl::Syntax::Methods
end
