require_relative "lib/gnc"

Gnc.prepare_load_path
Gnc.prepare_env

log_file = File.join(__dir__, "log", "#{Gnc.env}.log")
Gnc.logger = Logger.new(log_file, 10, 1_024_000)
Gnc.logger.level = Logger::WARN

Gnc.db_connection
