# frozen_string_literal: true

namespace :db do
  task :full_reset do
    desc "Fully reset the database, running db:reset, db:migrate, and db:seed"
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
  end

  task set_counter_caches: :environment do
    desc "Set counter caches so that they are accurate after seeding"
    Trip.all.each do |t|
      t.regular_plans_count = t.plans.count(&:regular_plan?)
      t.travel_plans_count = t.plans.count(&:travel_plan?)
      t.save

      Trip.reset_counters(t.id, :trip_memberships)
    end

    Plan.all.each do |p|
      Plan.reset_counters(p.id, :scannable_tickets, :ticket_links, :booking_references)
    end

    User.all.each do |u|
      u.trips_count = u.trip_memberships.count(:is_invite_accepted)
      u.save

      User.reset_counters(u.id, :referrals)
    end
  end
end
