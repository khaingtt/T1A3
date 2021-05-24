#!/usr/bin/env bash
set -Eeuo pipefail

echo 'This script will install all dependencies required by Khai Reminder App.'

gem install bundler
bundle install