ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.

# WORKAROUND Rails 6.1:
# https://stackoverflow.com/a/79379493
require "logger"

require "bootsnap/setup" # Speed up boot time by caching expensive operations.
