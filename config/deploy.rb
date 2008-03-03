set :application, "mydaddypuzzles"
set :repository,  "--username jkay --password jamon0665 svn+ssh://208.78.97.241/usr/local/svn/mydaddypuzzles"
set :deploy_to, "/usr/local/rails/#{application}"
set :runner, nil

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