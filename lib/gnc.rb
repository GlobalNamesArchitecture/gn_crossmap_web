# frozen_string_literal: true

# Gnc (Global Names Crossmap Web) module defines project's name space, sets
# environment and connection to the database
module Gnc
  ROOT_PATH = File.join(__dir__, "..")
  DEFAULT_ENV_FILE = File.join(ROOT_PATH, "config", "env.sh")

  class << self
    attr_writer :logger

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def env
      @env ||= ENV["RACK_ENV"] ? ENV["RACK_ENV"].to_sym : :development
    end

    def conf
      @conf ||= init_conf
    end

    def db_connection
      ActiveRecord::Base.logger = logger
      ActiveRecord::Base.logger.level = Logger::WARN
      ActiveRecord::Base.establish_connection(conf.database[env.to_s])
    end

    def prepare_env
      missing, extra = check_env
      return true if (missing + extra).empty?
      if env_empty?
        read_env
        missing, extra = check_env
      end
      raise("Missing env vars: #{missing.join(', ')}") unless missing.empty?
      raise("Extra env variables: #{extra.join(', ')}") unless extra.empty?
      true
    end

    def prepare_load_path
      $LOAD_PATH.unshift(File.join(ROOT_PATH, "models"))
      Dir.glob(File.join(ROOT_PATH, "models", "**", "*.rb")) do |model|
        require File.basename(model, ".*")
      end
    end

    def token
      rand(1e16..9e16).to_i.to_s(16)
    end

    private

    def check_env
      e_required = open(File.join(ROOT_PATH, "config", "env.sh")).map do |l|
        key, val = l.strip.split("=")
        val && key
      end.compact
      e_real = ENV.keys.select { |k| k =~ /^(RACKAPP_|RACK_ENV)/ }
      missing = e_required - e_real
      extra = e_real - e_required
      [missing, extra]
    end

    def env_empty?
      ENV.keys.select { |k| k =~ /RACKAPP_/ }.empty?
    end

    def init_conf
      raw_conf = File.read(File.join(ROOT_PATH, "config", "config.yml"))
      conf = YAML.load(ERB.new(raw_conf).result)
      OpenStruct.new(
        session_secret:   conf["session_secret"],
        database:         conf["database"],
        server:           conf["server"]
      )
    end

    def read_env
      env_file = DEFAULT_ENV_FILE
      env_file = ENV["ENV_FILE"] if ENV["ENV_FILE"]
      open(env_file).each do |l|
        key, val = l.strip.split("=")
        ENV[key.strip] = val.strip if key && val
      end
    end
  end
end
