require "bundler/capistrano"
require "rvm/capistrano"

set :application, "abtt"
set :repository,  "https://github.com/ABTech/abtt.git"
set :branch, "master"
set :deploy_to, "/srv/rails/abtt"
set :user, ''
set :domain, 'abtech-tracker-d02.andrew.cmu.edu'
set :rails_env, "production"
set :rvm_type, :system

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  desc "Symlink shared config files"
  task :symlink_config_files do
    run "#{ try_sudo } ln -s #{ deploy_to }/shared/config/secret_token.rb #{ release_path }/config/initializers/secret_token.rb"
  end
end

after "deploy:finalize_update", "deploy:symlink_config_files"
