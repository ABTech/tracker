ABTT_SERVER = "abtt.abtech.org"
set :application, "ABTT"
set :repository,  "git@github.com:ABTech/abtt.git"

# deploy_to is /u/apps/ABTT...

set :scm, :git

set :branch, fetch(:branch, "production")

role :web, ABTT_SERVER
role :app, ABTT_SERVER
role :db,  ABTT_SERVER, :primary => true

set :use_sudo, false # To deploy, you need to be in the unix group webmaster on the server

before :deploy, 'deploy:confirm'
after :deploy, 'postdeploy:verify'

namespace :deploy do
  task :confirm do
    puts "Please review the diff. If everything looks good, confirm deployment. Otherwise, cancel it."
    deploy.pending.diff
    print "Continue deployment (y/N)? " 
    raise "Aborting deployment now!" unless STDIN.gets.strip.downcase == "y"
  end
  task :start  do end
  task :stop do end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{release_path}/tmp/restart.txt"
  end
  after "deploy:setup" do
    run "touch #{deploy_to}/#{shared_dir}/database.yml"
  end
  after "deploy:update_code" do
    run "rm -f #{release_path}/config/database.yml && ln -s #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
  end
end

namespace :postdeploy do
  desc "Hit the http endpoints and make sure the server's still alive."
  task :verify do
    puts "Something seems to have esplodeded! Check https://#{ABTT_SERVER}/ and make sure it's still alive." unless %x{curl -kI https://#{ABTT_SERVER}/heartbeat|head -n1}.match /200 OK/
  end
end
