#!/usr/bin/env bash

set -e

chmod +x bin/rails

bundle install

# --- NEW EXPLICIT DATABASE COMMANDS ---
echo "--> Dropping existing database"
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bin/rails db:drop

echo "--> Creating new database"
bin/rails db:create

echo "--> Running database migrations (explicitly before seeding)"
bin/rails db:migrate

echo "--> Running database seeds"
bin/rails db:seed
# --- END OF NEW EXPLICIT DATABASE COMMANDS ---

echo "--> Precompiling assets"
bin/rails assets:precompile

echo "--> Build complete!"