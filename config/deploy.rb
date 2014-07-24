# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'fcc'
set :repo_url, ENV["GIT_REPO"] || 'git@github.com:chikim/fcc.git'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
# set :branch, "deploy"

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/staging/rails_app'
# set :resque_environment_task, true
set :resque_log_file, "log/resque.log"

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/run_code.sh}

# Default value for linked_dirs is []
set :linked_dirs, %w{
  bin
  log
  tmp/pids
  tmp/cache
  tmp/sockets
  tmp/test_cases
  tmp/submissions
  vendor/bundle
  public/system
}
set(:config_files, %w(
  nginx.conf
  database.example.yml
  unicorn.rb
  unicorn_init.sh
  run_code.sh
))

set(:executable_config_files, %w(
  unicorn_init.sh
  run_code.sh
))

set(:symlinks, [
  {
    source: "nginx.conf",
    link: "/etc/nginx/sites-enabled/{{full_app_name}}"
  },
  {
    source: "unicorn_init.sh",
    link: "/etc/init.d/unicorn_{{full_app_name}}"
  }
])
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do
  # make sure we're deploying what we think we're deploying
  # before :deploy, "deploy:check_revision"
  # only allow a deploy with passing tests to deployed
  # before :deploy, "deploy:run_tests"
  # compile assets locally then rsync
  after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'

  # remove the default nginx configuration as it will tend
  # to conflict with our configs.
  before 'deploy:setup_config', 'nginx:remove_default_vhost'

  # reload nginx to it will pick up any modified vhosts from
  # setup_config
  after 'deploy:setup_config', 'nginx:reload'

  # Restart monit so it will pick up any monit configurations
  # we've added
  # after 'deploy:setup_config', 'monit:restart'

  # As of Capistrano 3.1, the `deploy:restart` task is not called
  # automatically.
  after 'deploy:publishing', 'deploy:restart'
  after "deploy:restart", "resque:restart"

  # desc 'Restart application'
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     # Your restart mechanism here, for example:
  #     # execute :touch, release_path.join('tmp/restart.txt')
  #   end
  # end

  # after :publishing, :restart

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end


  namespace :rake do
    desc "Invoke rake task"
    task invoke: [:set_rails_env] do
      on primary fetch(:migration_role) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, "#{ENV['task']}"
          end
        end
      end
    end
  end
end
