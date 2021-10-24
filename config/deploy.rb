# frozen_string_literal: true

require 'mina/rails'
require 'mina/git'
require 'mina/rvm'    # for rvm support. (https://rvm.io)

set :application_name, 'skooteo'
set :deploy_to, '/home/deploy/skooteo'
set :user, 'deploy'          # Username in the server to SSH to.

task :production do
  set :domain, '52.221.47.201'
  set :repository, 'git@github.com:Skooteo/App.git'
  set :branch, 'master'
end

# task :staging do
#   set :domain, 'ec2-54-169-191-227.ap-southeast-1.compute.amazonaws.com'
#   set :repository, 'git@github.com:Skooteo/App.git'
#   set :branch, 'master'
# end

#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
# set :shared_dirs, fetch(:shared_dirs, []).push('public/assets')
set :shared_files, fetch(:shared_files, []).push('config/firebase.json')

namespace :systemctl do
  task :start, [:service] do |t, args|
    command %[sudo systemctl start #{args[:service]}]
  end

  task :restart, [:service] do |t, args|
    command %[sudo systemctl restart #{args[:service]}]
  end

  task :stop, [:service] do |t, args|
    command %[sudo systemctl stop #{args[:service]}]
  end

  task :status, [:service] do |t, args|
    command %[sudo systemctl status #{args[:service]}]
  end
end

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use', 'ruby-2.6.3@default'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
end

desc "Deploys the current version to the server."
task :deploy do
  invoke :'git:ensure_pushed'
  deploy do
    command %{source ~/.bash_profile}
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      invoke :'systemctl:restart', 'sidekiq.service'
      invoke :restart
      # in_path(fetch(:current_path)) do
      #   command %{mkdir -p tmp/}
      #   command %{touch tmp/restart.txt}
      # end
    end
  end

  run(:local) { puts 'done' }
end

task :restart do
  comment 'Restart application'
  command "passenger-config restart-app --ignore-app-not-running /home/deploy/skooteo"
end
