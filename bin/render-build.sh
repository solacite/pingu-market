#!/usr/bin/env bash

set -o errexit
chmod +x bin/rails

bundle install
bin/rails assets:precompile
bin/rails assets:clean

DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bin/rails db:reset
bin/rails assets:precompile