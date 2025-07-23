#!/usr/bin/env bash

set -e

chmod +x bin/rails

bundle install

echo "--> Running database migrations"
bin/rails db:migrate

echo "--> Running database seeds"
bin/rails db:seed

echo "--> Precompiling assets"
bin/rails assets:precompile

echo "--> Build complete!"