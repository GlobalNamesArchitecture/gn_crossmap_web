#!/bin/bash

until [[ "$(mysqladmin status -u ${RACKAPP_DB_USERNAME} -h ${RACKAPP_DB_HOST} -p${RACKAPP_DB_PASSWORD})" =~ "Uptime" ]]; do
  echo "Waiting for mysql to start..."
  sleep 1
done

bundle exec rake db:drop
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:migrate RACK_ENV=test
rackup -o 0.0.0.0
