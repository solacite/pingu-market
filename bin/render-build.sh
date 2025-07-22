#!/usr/bin/env bash

set -o errexit
chmod +x bin/rails

bundle install
bin/rails assets:precompile
bin/rails assets:clean

bin/rails db:reset
bin/rails assets:precompile