# frozen_string_literal: true

namespace :db do
  desc "Fully reset the database, running db:reset, db:migrate, and db:seed"
  task :full_reset do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
  end
end
