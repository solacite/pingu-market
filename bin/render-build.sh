#!/usr/bin/env bash

set -e

chmod +x bin/rails

bundle install

# --- START OF NEW LINES TO ADD ---
echo "--> Terminating existing database connections"
# Extract database name from DATABASE_URL
DB_NAME=$(echo $DATABASE_URL | sed -n 's/.*\/\|\?.*//p')
# Use psql to kill all other connections to the database
psql $DATABASE_URL -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${DB_NAME}' AND pid <> pg_backend_pid();"
# --- END OF NEW LINES TO ADD ---

echo "--> Running database reset (dropping, creating, migrating, and seeding)"
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bin/rails db:reset

echo "--> Precompiling assets"
bin/rails assets:precompile

echo "--> Build complete!"