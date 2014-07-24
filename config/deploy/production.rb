set :rvm_type, :local # Defaults to: :auto
# set :rvm_ruby_version, '2.1.2@sopkast'      # Defaults to: 'default'
set :ssh_options, {
  port: 1112
}
set :rvm_custom_path, '/usr/local/rvm'  # only needed if not detected
set :ip_server, "118.70.170.72"
set :stage, :production
set :rails_env, :production
set :unicorn_worker_count, 3
set :enable_ssl, false
set :deployer, "staging"
role :resque_worker, fetch(:ip_server)
role :resque_scheduler, fetch(:ip_server)
set :workers, { "*" => 10 }
# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

# role :app, %w{deploy@example.com}
# role :web, %w{deploy@example.com}
# role :db,  %w{deploy@example.com}

set :server_name, "codecontest.framgia.com"
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"

server fetch(:ip_server), user: 'staging', roles: %w{web app db}, primary: true
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

# role :app, %w{deploy@example.com}
# role :web, %w{deploy@example.com}
# role :db,  %w{deploy@example.com}
#
#
# # Extended Server Syntax
# # ======================
# # This can be used to drop a more detailed server definition into the
# # server list. The second argument is a, or duck-types, Hash and is
# # used to set extended properties on the server.
#
# server 'example.com', user: 'deploy', roles: %w{web app}, my_property: :my_value


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
