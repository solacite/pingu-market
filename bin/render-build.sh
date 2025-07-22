#!/usr/bin/env bash

set -o errexit
chmod +x bin/rails

bundle install
bin/rails assets:precompile
bin/rails assets:clean

bin/rails db:migrate

echo "--> Running database seeds"
bin/rails db:seed
bin/rails assets:precompile