# frozen_string_literal: true

# == Schema Information
#
# Table name: plans
#
#  id                       :bigint           not null, primary key
#  booking_references_count :integer          default(0), not null
#  end_date                 :datetime
#  end_location_latitude    :decimal(, )
#  end_location_longitude   :decimal(, )
#  end_location_name        :string
#  plan_type                :integer          not null
#  provider_name            :string
#  scannable_tickets_count  :integer          default(0), not null
#  start_date               :datetime
#  start_location_latitude  :decimal(, )
#  start_location_longitude :decimal(, )
#  start_location_name      :string
#  ticket_links_count       :integer          default(0), not null
#  title                    :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  backup_plan_id           :bigint
#  trip_id                  :bigint
#
# Indexes
#
#  index_plans_on_backup_plan_id  (backup_plan_id)
#  index_plans_on_trip_id         (trip_id)
#
# Foreign Keys
#
#  fk_rails_...  (backup_plan_id => plans.id)
#
require "rails_helper"
require_relative "../concerns/countable_shared_examples"

RSpec.describe(Plan, type: :model) do
  let(:trip) { create(:trip) }

  it_behaves_like "countable"

  describe "#add_counter_cache" do
    context "when creating a travel plan" do
      let(:plan) { create(:plan, trip: trip, plan_type: "travel_by_foot") }
      it "increments travel_plans_count" do
        expect { plan }.to(change(trip, :travel_plans_count).by(1))
      end

      it "doesn't change regular_plans_count" do
        expect { plan }.to(change(trip, :regular_plans_count).by(0))
      end
    end

    context "when creating a regular plan" do
      let(:plan) { create(:plan, trip: trip, plan_type: "active") }
      it "increments regular_plans_count" do
        expect { plan }.to(change(trip, :regular_plans_count).by(1))
      end

      it "doesn't change travel_plans_count" do
        expect { plan }.to(change(trip, :travel_plans_count).by(0))
      end
    end
  end

  describe "#remove_counter_cache" do
    context "when removing a travel plan" do
      let!(:plan) { create(:plan, trip: trip, plan_type: "travel_by_foot") }
      subject { plan.destroy! }

      it "decrements travel_plans_count" do
        expect { subject }.to(change(trip, :travel_plans_count).by(-1))
      end

      it "doesn't change regular_plans_count" do
        expect { plan }.to(change(trip, :regular_plans_count).by(0))
      end
    end

    context "when removing a regular plan" do
      let!(:plan) { create(:plan, trip: trip, plan_type: "active") }
      subject { plan.destroy! }

      it "decrements regular_plans_count" do
        expect { subject }.to(change(trip, :regular_plans_count).by(-1))
      end

      it "doesn't change travel_plans_count" do
        expect { plan }.to(change(trip, :travel_plans_count).by(0))
      end
    end
  end

  describe "#update_counter_cache" do
    context "when updating a travel plan to be a regular plan" do
      let!(:plan) { create(:plan, trip: trip, plan_type: "travel_by_foot") }
      subject { plan.update!(plan_type: "active") }

      it "increments the trip's regular_plans_count" do
        expect { subject }.to(change(trip, :regular_plans_count).by(1))
      end

      it "decrements the trip's travel_plans_count" do
        expect { subject }.to(change(trip, :travel_plans_count).by(-1))
      end
    end

    context "when updating a travel plan to be a different travel plan" do
      let!(:plan) { create(:plan, trip: trip, plan_type: "travel_by_foot") }
      subject { plan.update!(plan_type: "travel_by_boat") }

      it "doesn't change the trip's regular_plans_count" do
        expect { subject }.to(change(trip, :regular_plans_count).by(0))
      end

      it "doesn't change the trip's travel_plans_count" do
        expect { subject }.to(change(trip, :travel_plans_count).by(0))
      end
    end

    context "when updating a regular plan to be a travel plan" do
      let!(:plan) { create(:plan, trip: trip, plan_type: "active") }
      subject { plan.update!(plan_type: "travel_by_foot", end_location_name: "Mock End Location Name") }

      it "decrements the trip's regular_plans_count" do
        expect { subject }.to(change(trip, :regular_plans_count).by(-1))
      end

      it "increments the trip's travel_plans_count" do
        expect { subject }.to(change(trip, :travel_plans_count).by(1))
      end
    end

    context "when updating a regular plan to be a different type of regular plan" do
      let!(:plan) { create(:plan, trip: trip, plan_type: "active") }
      subject { plan.update!(plan_type: "other") }

      it "doesn't change the trip's regular_plans_count" do
        expect { subject }.to(change(trip, :regular_plans_count).by(0))
      end

      it "doesn't change the trip's travel_plans_count" do
        expect { subject }.to(change(trip, :travel_plans_count).by(0))
      end
    end
  end

  describe "#regular_plan?" do
    context "when the plan is a regular plan" do
      let(:plan) { create(:plan, trip: trip, plan_type: "active") }
      it "returns true" do
        expect(plan.regular_plan?).to(be_truthy)
      end
    end

    context "when the plan is a travel plan" do
      let(:plan) { create(:plan, trip: trip, plan_type: "travel_by_foot") }
      it "returns false" do
        expect(plan.regular_plan?).to(be_falsey)
      end
    end
  end

  describe "#travel_plan?" do
    context "when the plan is a travel plan" do
      let(:plan) { create(:plan, trip: trip, plan_type: "travel_by_foot") }
      it "returns true" do
        expect(plan.travel_plan?).to(be_truthy)
      end
    end

    context "when the plan is a regular plan" do
      let(:plan) { create(:plan, trip: trip, plan_type: "active") }
      it "returns false" do
        expect(plan.travel_plan?).to(be_falsey)
      end
    end
  end

  describe "#any_tickets?" do
    context "when the plan has ticket links" do
      let(:plan) { create(:plan, trip: trip, ticket_links_count: 1) }
      it "returns true" do
        expect(plan.any_tickets?).to(be_truthy)
      end
    end

    context "when the plan has booking references" do
      let(:plan) { create(:plan, trip: trip, booking_references_count: 1) }
      it "returns true" do
        expect(plan.any_tickets?).to(be_truthy)
      end
    end

    context "when the plan has scannable tickets" do
      let(:plan) { create(:plan, trip: trip, scannable_tickets_count: 1) }
      it "returns true" do
        expect(plan.any_tickets?).to(be_truthy)
      end
    end

    context "when the plan has no tickets" do
      let(:plan) { create(:plan, trip: trip) }
      it "returns false" do
        expect(plan.any_tickets?).to(be_falsey)
      end
    end
  end

  describe "#free_time_plan?" do
    context "when the plan is a free time plan" do
      let(:plan) { create(:plan, trip: trip, plan_type: "free_time") }
      it "returns true" do
        expect(plan.free_time_plan?).to(be_truthy)
      end
    end

    context "when the plan is not a free time plan" do
      let(:plan) { create(:plan, trip: trip, plan_type: "active") }
      it "returns false" do
        expect(plan.free_time_plan?).to(be_falsey)
      end
    end
  end

  describe "#backup_plan?" do
    context "when the plan is a backup plan" do
      let(:plan) { create(:plan, trip: trip, primary_plan: create(:plan)) }
      it "returns true" do
        expect(plan.backup_plan?).to(be_truthy)
      end
    end

    context "when the plan is not a backup plan" do
      let(:plan) { create(:plan, trip: trip) }
      it "returns false" do
        expect(plan.backup_plan?).to(be_falsey)
      end
    end

    context "when the plan is a primary plan" do
      let(:plan) { create(:plan, trip: trip) }
      it "returns false" do
        expect(plan.backup_plan?).to(be_falsey)
      end
    end
  end

  describe "#primary_plan_id=" do
    let(:plan) { create(:plan, trip: trip) }
    let(:backup_plan) { create(:plan, trip: trip) }

    it "sets the primary_plan association" do
      plan.primary_plan_id = backup_plan.id
      expect(plan.primary_plan).to(eq(backup_plan))
    end

    it "does not set the primary_plan association if the ID is nil" do
      plan.primary_plan_id = nil
      expect(plan.primary_plan).to(be_nil)
    end
  end

  describe "#start_within_trip_dates" do
    let(:plan) { build(:plan, trip: trip) }

    context "when the start date is within the trip dates" do
      it "is valid" do
        plan.start_date = trip.start_date + 1.day
        expect(plan.valid?).to(be_truthy)
      end
    end

    context "when the start date is before the trip start date" do
      it "is invalid" do
        plan.start_date = trip.start_date - 1.day
        expect(plan.valid?).to(be_falsey)
        expect(plan.errors[:start_date]).to(include("must be within the trip dates"))
      end
    end

    context "when the start date is after the trip end date" do
      it "is invalid" do
        plan.start_date = trip.end_date + 1.day
        expect(plan.valid?).to(be_falsey)
        expect(plan.errors[:start_date]).to(include("must be within the trip dates"))
      end
    end
  end

  describe "#end_within_trip_dates" do
    let(:plan) { build(:plan, trip: trip, start_date: trip.start_date) }

    context "when the end date is within the trip dates" do
      it "is valid" do
        plan.end_date = trip.start_date + 1.day
        expect(plan.valid?).to(be_truthy)
      end
    end

    context "when the end date is before the trip start date" do
      it "is invalid" do
        plan.end_date = trip.start_date - 1.day
        expect(plan.valid?).to(be_falsey)
        expect(plan.errors[:end_date]).to(include("must be within the trip dates"))
      end
    end

    context "when the end date is after the trip end date" do
      it "is invalid" do
        plan.end_date = trip.end_date + 1.day
        expect(plan.valid?).to(be_falsey)
        expect(plan.errors[:end_date]).to(include("must be within the trip dates"))
      end
    end
  end
end
