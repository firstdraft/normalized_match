# frozen_string_literal: true

require "bundler/setup"
require "git/lint/rake/register"
require "rspec/core/rake_task"

Git::Lint::Rake::Register.call
RSpec::Core::RakeTask.new { |task| task.verbose = false }

desc "Run code quality checks"
task quality: %i[git_lint]

task default: %i[quality spec]
