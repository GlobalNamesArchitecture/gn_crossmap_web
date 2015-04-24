require_relative "../environment"
require_relative "checklist/errors"
require_relative "checklist/version"

# All-encompassing module of the project
module checklist
  class << self
    attr_writer :logger

    def logger
      @logger ||= Logger.new("/dev/null")
    end
end
