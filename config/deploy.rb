set :application, "mydaddypuzzles"
set :user, 'deploy'
set :scm, :git
set :deploy_via, :remote_cache
set :repository,  "deploy@justinbkay.org:/var/git/mydaddypuzzles.git"
set :deploy_to, "/usr/local/rails/#{application}"
set :runner, 'deploy'
set :svn, "/usr/bin/svn"
set :ssh, "/usr/bin/ssh"


# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "208.53.44.52"
role :web, "208.53.44.52"
role :db,  "208.53.44.52", :primary => true

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

desc "commit article pics to git"
task :commit_pics do
  run "cd #{current_path} && git add public/images/full_size/*"
  run "cd #{current_path} && git add public/images/thumbnails/*"
  run "cd #{current_path} && git add public/images/articles/*"
  run 'cd #{current_path} && git commit -v -a -m "adding pic"'
end
before "deploy:update", "commit_pics"