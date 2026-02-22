#!/bin/bash
set -e

bundle exec rails db:migrate:primary &
bundle exec rails db:migrate:queue &
bundle exec rails s -p 8080 -b 0.0.0.0