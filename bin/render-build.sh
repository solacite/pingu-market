#!/usr/bin/env bash

set -e

chmod +x bin/rails

bundle install

echo "--> Dropping existing database"
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bin/rails db:drop

echo "--> Creating new database"
bin/rails db:create

echo "--> Loading database schema from schema.rb"
bin/rails db:schema:load

echo "--> Running database seeds"
bin/rails db:seed

echo "--> Precompiling assets"
bin/rails assets:precompile

echo "--> Build complete!"