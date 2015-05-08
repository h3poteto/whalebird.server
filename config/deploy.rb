# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'whalebird.server'
set :repo_url, 'git@github.com:h3poteto/whalebird.server'

# Default branch is :master
set :branch, 'master'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/srv/www/whalebird.server'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

set :linked_dirs, %w{log tmp/backup tmp/pids tmp/sockets vendor/bundle certification}
set :linked_files, %w{config/application.yml config/settings/production.local.yml lib/extras/application_secrets.rb}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

set :rbenv_path, '~/.rbenv'
set :rbenv_type, :system
set :rbenv_ruby, '2.1.3'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"
set :unicorn_config_path, "#{release_path}/config/unicorn.rb"

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

set :sidekiq_config, -> { File.join(release_path, 'config', 'sidekiq.yml') }
set :sidekiq_role, :web


after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  desc 'restart'
  task :restart do
    invoke 'unicorn:restart'
  end

  desc 'Upload local config yml'
  task :upload do
    on roles(:app) do |host|
      unless test "[ -d #{shared_path}/config ]"
        execute "mkdir -p #{shared_path}/config"
      end
      unless test "[ -d #{shared_path}/config/settings ]"
        execute "mkdir -p #{shared_path}/config/settings"
      end
      upload!('config/application.production.yml', "#{shared_path}/config/application.yml")
      upload!('config/settings/production.local.yml', "#{shared_path}/config/settings/production.local.yml")

      unless test"[ -d #{shared_path}/lib/extras ]"
        execute "mkdir -p #{shared_path}/lib/extras"
      end
      upload!('lib/extras/application_secrets.rb', "#{shared_path}/lib/extras/application_secrets.rb")

      unless test"[ -d #{shared_path}/certification ]"
        execute "mkdir -p #{shared_path}"
      end
      upload!('certification', "#{shared_path}", :recursive => true)
    end
  end
  before :starting, 'deploy:upload'
  after :finishing, 'deploy:cleanup'
end
