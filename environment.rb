require_relative "lib/checklist"

Checklist.prepare_load_path
Checklist.prepare_env

if Checklist.env == :production
  log_file = File.join(settings.root, "logs", "production.log")
  Checklist.logger = Logger.new(log_file, 10, 1_024_000)
  Checklist.logger = Logger::WARN
end

# Checklist.db_connection
