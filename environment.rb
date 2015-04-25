require_relative "lib/checklist"

Checklist.prepare_load_path
Checklist.prepare_env

log_file = File.join(settings.root, "log", "#{Checklist.env}.log")
Checklist.logger = Logger.new(log_file, 10, 1_024_000)
Checklist.logger.level = Logger::WARN

Checklist.db_connection
