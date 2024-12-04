# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

# Prerequisite task for rake spec, ensuring that all factories have valid definitions before other tests run
# from https://thoughtbot.com/blog/testing-your-factories-first
if defined?(RSpec)
  desc "Run factory specs."
  RSpec::Core::RakeTask.new(:factory_specs) do |t|
    t.pattern = "./spec/factories_spec.rb"
  end
end

task spec: :factory_specs
