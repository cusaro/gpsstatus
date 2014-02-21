set :application, 'gpsstatus'
set :deploy_user, 'alex'

# setup repo details
set :scm, :git
set :repo_url, 'git@bitbucket.org:ddpdirect/gpsstatus.git'

# setup rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.0.0-p353'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

# how many old releases do we want to keep
set :keep_releases, 5

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :bundle_binstubs, false

# what specs should be run before deployment is allowed to# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, ["spec"]

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  # only allow a deploy with passing tests to deployed
  #before :deploy, "deploy:run_tests"

  # make sure we're deploying what we think we're deploying
  #before :deploy, "deploy:check_revision"

  # compile assets locally then rsync
  #after 'deploy:symlink:shared', 'deploy:compile_assets_locally'



  after :finishing, 'deploy:cleanup'
end
