# frozen_string_literal: true

# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Load additional modules
require "capistrano/rvm"
require "capistrano/bundler"
require "capistrano/yarn"
require "capistrano/rails/assets"
require "capistrano/rails/migrations"
require "capistrano/passenger"
require "whenever/capistrano"

# Configure the SCM
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Load custom tasks from `lib/capistrano/tasks' if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
