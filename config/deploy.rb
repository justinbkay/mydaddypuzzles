set :application, "mydaddypuzzles"
set :repository,  "svn+ssh://208.78.97.241/usr/local/svn/mydaddypuzzles"
set :deploy_to, "/usr/local/rails/#{application}"
set :runner, 'root'
set :svn, "/usr/bin/svn"
set :ssh, "/usr/bin/ssh"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "208.78.97.241"
role :web, "208.78.97.241"
role :db,  "208.78.97.241", :primary => true

desc "start thin web server"
task :start_thin do
  run "cd #{release_path} && /usr/bin/thin start -C config/thin.yml -d"
end
after "deploy:restart", "start_thin"

desc "commit article pics to svn"
task :commit_pics do
  run "cd #{current_path} && svn add public/images/full_size/*"
  run "cd #{current_path} && svn ci public/images/full_size/* -m \"adding pic\""
  run "cd #{current_path} && svn add public/images/thumbnails/*"
  run "cd #{current_path} && svn ci public/images/thumbnails/* -m \"adding pic\""
  run "cd #{current_path} && svn add public/images/articles/*"
  run "cd #{current_path} && svn ci public/images/articles/* -m \"adding pic\""
end
before "deploy:update", "commit_pics"