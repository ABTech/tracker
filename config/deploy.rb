require "bundler/capistrano"
require "rvm/capistrano"
require 'thinking_sphinx/capistrano'

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

set :application, "abtt"
set :repository,  "https://github.com/ABTech/abtt.git"
set :branch, "production"
set :deploy_to, "/srv/rails/abtt"
set :user, ''
set :domain, 'tracker.abtech.org'
set :rails_env, "production"
set :rvm_type, :system
set :rvm_bin_path, '/usr/local/rvm/bin'
set :rvm_ruby_string, :local
set :rvm_autolibs_flag, 'packages'
set :rvm_install_type, :head

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
    run "#{ try_sudo } ln -s #{ deploy_to }/shared/config/secrets.yml #{ release_path }/config/secrets.yml"
    run "#{ try_sudo } ln -s #{ deploy_to }/shared/config/mail_room.cfg #{ release_path }/config/mail_room.cfg"
  end
  
  desc "Create shared Thinking Sphinx folder"
  task :shared_sphinx_folder do
    run "mkdir #{deploy_to}/shared/sphinx"
  end
end

namespace :mail_room do
  %w[start stop restart].each do |command|
    task command, roles: :app, :except => { :no_release => true } do
      run "if [ -L /etc/init.d/abtt_mail_room ]; then #{try_sudo} /etc/init.d/abtt_mail_room #{command}; fi"
    end
  end
  
  desc "Install mail_room service"
  task :setup, roles: :app do
    run "if [ ! -L /etc/init.d/abtt_mail_room -a -f #{current_path}/mail_room-init.d ]; then \
      #{try_sudo} ln -nfs #{current_path}/mail_room-init.d /etc/init.d/abtt_mail_room && \
      #{try_sudo} chmod +x #{current_path}/mail_room-init.d && \
      #{try_sudo} chmod o-w #{current_path}/mail_room-init.d && \
      #{try_sudo} update-rc.d abtt_mail_room defaults ; \
    elif [ -f #{current_path}/mail_room-init.d ]; then \
      #{try_sudo} chmod +x #{current_path}/mail_room-init.d && \
      #{try_sudo} chmod o-w #{current_path}/mail_room-init.d ; \
    fi"
  end
  
  desc "Setup mail_room service configuration"
  task :defaults, roles: :app do
    run "#{try_sudo} sh -c 'echo \"ABTT_DIR=#{current_path}\" > /etc/default/abtt_mail_room'"
  end
end

after "deploy:finalize_update", "deploy:symlink_config_files"

require "rvm/capistrano/alias_and_wrapp"
before 'deploy', 'mail_room:stop'
before 'deploy', 'rvm:create_alias'
before 'deploy', 'rvm:create_wrappers'
after 'deploy', 'mail_room:setup'
after 'mail_room:setup', 'mail_room:start'
after 'deploy:setup', 'mail_room:defaults'
after 'deploy:setup', 'deploy:shared_sphinx_folder'
