# frozen_string_literal: true

app_dir = "/app"
ENV["RACK_ENV"] ||= "development" # not sure about this

working_directory app_dir

pid "#{app_dir}/tmp/unicorn.pid"

stderr_path "#{app_dir}/log/unicorn.stderr.log"
stdout_path "#{app_dir}/log/unicorn.stdout.log"

workers_num = ENV["RACKAPP_UNICORN_WORKERS"].to_i
workers_num = 1 if workers_num.zero?
worker_processes workers_num

listen 8080, tcp_nopush: true
timeout 30
