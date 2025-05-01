# frozen_string_literal: true

require "rails_helper"
require_relative "../support/helpers/global_helper"

def populate_database
  create(model.to_s.underscore.to_sym, created_at: Time.zone.parse("2024-01-01 08:30:00"))
  create(model.to_s.underscore.to_sym, created_at: Time.zone.parse("2024-01-01 23:30:00"))
  create(model.to_s.underscore.to_sym, created_at: Time.zone.parse("2024-01-05 14:14:14"))
  create(model.to_s.underscore.to_sym, created_at: Time.zone.parse("2024-01-26 08:30:00"))
  create(model.to_s.underscore.to_sym, created_at: Time.zone.parse("2024-07-26 08:30:00"))
  create(model.to_s.underscore.to_sym, created_at: Time.zone.parse("2025-01-01 08:30:00"))
end

RSpec.shared_examples_for("countable") do
  let(:model) { described_class }

  describe ".count_by_day" do
    context "when there is nothing in the database" do
      it "returns an empty hash" do
        expect(model.count_by_day).to(eq({}))
      end
    end

    context "when the database is populated" do
      before { populate_database }

      it "groups by day" do
        by_day = model.count_by_day
        expect(by_day).to(eq({
          Time.zone.parse("2024-01-01") => 2,
          Time.zone.parse("2024-01-05") => 1,
          Time.zone.parse("2024-01-26") => 1,
          Time.zone.parse("2024-07-26") => 1,
          Time.zone.parse("2025-01-01") => 1,
        }))
      end
    end
  end

  describe ".count_by_week" do
    context "when there is nothing in the database" do
      it "returns an empty hash" do
        expect(model.count_by_week).to(eq({}))
      end
    end

    context "when the database is populated" do
      before { populate_database }

      it "groups by week, with the key being the first day of the week" do
        by_week = model.count_by_week
        expect(by_week).to(eq({
          Time.zone.parse("2024-01-01") => 3,
          Time.zone.parse("2024-01-22") => 1,
          Time.zone.parse("2024-07-22") => 1,
          Time.zone.parse("2024-12-30") => 1,
        }))
      end
    end
  end

  describe ".count_by_month" do
    context "when there is nothing in the database" do
      it "returns an empty hash" do
        expect(model.count_by_month).to(eq({}))
      end
    end

    context "when the database is populated" do
      before { populate_database }

      it "groups by month" do
        by_month = model.count_by_month
        expect(by_month).to(eq({
          Time.zone.parse("2024-01-01") => 4,
          Time.zone.parse("2024-07-01") => 1,
          Time.zone.parse("2025-01-01") => 1,
        }))
      end
    end
  end

  describe ".count_today" do
    before do
      time_travel_everywhere(Time.zone.parse("2024-01-01"))
    end
    after do
      time_travel_back
    end

    context "when there is nothing in the database" do
      it "returns 0" do
        expect(model.count_today).to(eq(0))
      end
    end

    context "when the database is populated" do
      before { populate_database }
      it "returns the number of items created today" do
        expect(model.count_today).to(eq(2))
      end
    end
  end

  describe ".count_this_week" do
    before do
      time_travel_everywhere(Time.zone.parse("2024-01-01"))
    end
    after do
      time_travel_back
    end

    context "when there is nothing in the database" do
      it "returns 0" do
        expect(model.count_this_week).to(eq(0))
      end
    end

    context "when the database is populated" do
      before { populate_database }
      it "returns the number of items created this week" do
        expect(model.count_this_week).to(eq(3))
      end
    end
  end

  describe ".count_this_month" do
    before do
      time_travel_everywhere(Time.zone.parse("2024-01-01"))
    end
    after do
      time_travel_back
    end

    context "when there is nothing in the database" do
      it "returns 0" do
        expect(model.count_this_month).to(eq(0))
      end
    end

    context "when the database is populated" do
      before { populate_database }
      it "returns the number of items created this month" do
        expect(model.count_this_month).to(eq(4))
      end
    end
  end
end
