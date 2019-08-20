# config valid only for current version of Capistrano
lock "3.10.1"

set :application, "abtt"
set :repo_url, "https://github.com/ABTech/tracker.git"

# Default branch is :master
# set :branch, :master

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/srv/rails/abtt"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/email.yml", "config/groupme.yml", "config/secrets.yml", "config/slack.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# rvm
set :rvm_type, :system
set :rvm_custom_path, '/usr/local/rvm'

# rails
set :rails_env, 'production'
set :conditionally_migrate, true
set :migration_role, :app
set :assets_roles, [:app]

# whenever
set :whenever_roles, :app
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# foreman
after :'deploy:publishing', :'foreman_systemd:restart'
set :foreman_systemd_user, "deploy"
append :rvm_map_bins, "foreman"
append :bundle_bins, "foreman"

# sphinx
set :thinking_sphinx_roles, :app

# passenger
set :passenger_restart_with_touch, true
