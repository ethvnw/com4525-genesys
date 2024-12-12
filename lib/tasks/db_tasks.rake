# frozen_string_literal: true

namespace :db do
  task :full_reset do
    desc "Fully reset the database, running db:reset, db:migrate, and db:seed"
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
  end
end
