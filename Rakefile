#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Challengesplatform::Application.load_tasks

if Rails.env == 'test'
  require 'rspec/core/rake_task'
  # RSpec::Core::RakeTask.new(:spec)

  require 'coveralls/rake/task'

  Coveralls::RakeTask.new
  task :test_with_coveralls => [:spec, :cucumber, 'coveralls:push']
end
