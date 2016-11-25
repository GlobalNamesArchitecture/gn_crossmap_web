#!/bin/bash

while [[ "$(pg_isready -h ${RACKAPP_DB_HOST} -U ${RACKAPP_DB_USERNAME})" =~ "no response" ]]; do
  echo "Waiting for postgresql to start..."
  sleep 1
done

bundle exec rake db:drop
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:migrate RACK_ENV=test
rackup -o 0.0.0.0
