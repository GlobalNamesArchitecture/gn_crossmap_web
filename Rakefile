require "bundler"
require "active_record"
require "rake"
require "rspec"
require "git"
require "rspec/core/rake_task"
require "sinatra/activerecord/rake"
require_relative "lib/sysopia"

task default: :spec

RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*spec.rb"
end

include ActiveRecord::Tasks
ActiveRecord::Base.configurations =
  YAML.load(File.read("config/config.yml"))["database"]

namespace :db do
  desc "create all the databases from config.yml"
  namespace :create do
    task(:all) do
      DatabaseTasks.create_all
    end
  end

  desc "drop all the databases from config.yml"
  namespace :drop do
    task(:all) do
      DatabaseTasks.drop_all
    end
  end

  desc "redo last migration"
  task redo: ["db:rollback", "db:migrate"]
end

desc "prepares everything for tests"
task :testup do
  system("rake db:migrate SYSOPIA_ENV=test")
  system("rake seed SYSOPIA_ENV=test")
end

desc "create release on github"
task(:release) do
  require "git"
  begin
    g = Git.open(File.dirname(__FILE__))
    new_tag = Sysopia.version
    g.add_tag("v#{new_tag}")
    g.add(all: true)
    g.commit("Releasing version #{new_tag}")
    g.push(tags: true)
  rescue Git::GitExecuteError
    puts "'v#{new_tag}' already exists, update your version."
  end
end

desc "populate seed data for tests"
task :seed do
  require_relative "db/seed"
end

desc "open an irb session preloaded with this library"
task :console do
  sh "irb -I lib -I extra -r sysopia.rb"
end
