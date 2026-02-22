#!/bin/bash
set -e

bundle exec rails db:migrate:primary &
bundle exec rails db:migrate:queue &
bundle exec puma -C "config/puma.rb" -p 8081 -t 1:1 -w 0 &
bundle exec bin/jobs