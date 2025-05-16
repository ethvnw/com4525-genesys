# frozen_string_literal: true

# == Schema Information
#
# Table name: trips
#
#  id                     :bigint           not null, primary key
#  description            :string
#  end_date               :datetime
#  location_latitude      :decimal(, )
#  location_longitude     :decimal(, )
#  location_name          :string
#  regular_plans_count    :integer          default(0), not null
#  start_date             :datetime
#  title                  :string           not null
#  travel_plans_count     :integer          default(0), not null
#  trip_memberships_count :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_trips_on_start_date  (start_date)
#
require "rails_helper"
require_relative "../concerns/countable_shared_examples"

RSpec.describe(Trip, type: :model) do
  it_behaves_like "countable"

  describe "validations" do
    let(:trip) { build(:trip) }

    describe "#date_range_cant_be_blank" do
      context "when start_date is blank" do
        it "adds an error" do
          trip.start_date = nil
          expect(trip).to(be_invalid)
          expect(trip.errors[:date]).to(include("can't be blank"))
        end
      end

      context "when end_date is blank" do
        it "adds an error" do
          trip.end_date = nil
          expect(trip).to(be_invalid)
          expect(trip.errors[:date]).to(include("can't be blank"))
        end
      end

      context "when both dates are not blank" do
        it "validates successfully" do
          travel_to Time.zone.parse("2020-01-01")
          trip.end_date = Time.zone.now
          trip.start_date = Time.zone.now

          expect(trip).to(be_valid)
          expect(trip.errors[:date]).to(be_empty)
        end
      end
    end

    describe "#start_date_cannot_be_in_the_past" do
      before do
        travel_to Time.zone.parse("2020-01-01 16:00:00")
      end

      context "when start_date is in the past" do
        it "adds an error" do
          trip.start_date = Time.zone.now - 1.day
          expect(trip).to(be_invalid)
          expect(trip.errors[:start_date]).to(include("cannot be in the past"))
        end
      end

      context "when start_date is in the future" do
        it "validates successfully" do
          trip.start_date = Time.zone.now + 1.day
          expect(trip).to(be_valid)
          expect(trip.errors[:start_date]).to(be_empty)
        end
      end

      context "when start_date is the current calendar day, but the time is in the past" do
        it "validates successfully" do
          trip.start_date = Time.zone.parse("2020-01-01 12:00:00")
          expect(trip).to(be_valid)
          expect(trip.errors[:start_date]).to(be_empty)
        end
      end
    end

    describe "#location_cant_be_blank" do
      context "when location name is blank" do
        it "adds an error" do
          trip.location_name = nil
          expect(trip).to(be_invalid)
          expect(trip.errors[:location]).to(include("can't be blank"))
        end
      end

      context "when location latitude is blank" do
        it "adds an error" do
          trip.location_latitude = nil
          expect(trip).to(be_invalid)
          expect(trip.errors[:location]).to(include("can't be blank"))
        end
      end

      context "when location longitude is blank" do
        it "adds an error" do
          trip.location_longitude = nil
          expect(trip).to(be_invalid)
          expect(trip.errors[:location]).to(include("can't be blank"))
        end
      end

      context "when all location information is present" do
        it "validates successfully" do
          trip.location_name = "mock location"
          trip.location_latitude = 0.0
          trip.location_longitude = 0.0
          expect(trip).to(be_valid)
          expect(trip.errors[:location]).to(be_empty)
        end
      end
    end

    describe "#single_date_validation" do
      context "when start_date and end_date are the same" do
        let(:trip) do
          build(
            :trip,
            start_date: Time.zone.parse("2020-01-01 12:00:00"),
            end_date: Time.zone.parse("2020-01-01 12:00:00"),
          )
        end

        it "sets start_date to beginning of day and end_date to end of day" do
          trip.valid?
          # The usec is set to 0 to avoid precision issues
          expect(trip.start_date.change(usec: 0)).to(eq(Time.zone.parse("2020-01-01 00:00:00")))
          expect(trip.end_date.change(usec: 0)).to(eq(Time.zone.parse("2020-01-01 23:59:59")))
        end
      end

      context "when start_date and end_date are different" do
        let(:trip) do
          build(
            :trip,
            start_date: Time.zone.parse("2020-01-01 12:00:00"),
            end_date: Time.zone.parse("2020-01-02 12:00:00"),
          )
        end

        it "does not modify the dates" do
          trip.valid?
          # The usec is set to 0 to avoid precision issues
          expect(trip.start_date.change(usec: 0)).to(eq(Time.zone.parse("2020-01-01 12:00:00")))
          expect(trip.end_date.change(usec: 0)).to(eq(Time.zone.parse("2020-01-02 12:00:00")))
        end
      end
    end
  end
end
