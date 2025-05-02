# frozen_string_literal: true

# == Schema Information
#
# Table name: plans
#
#  id                       :bigint           not null, primary key
#  end_date                 :datetime
#  end_location_latitude    :decimal(, )
#  end_location_longitude   :decimal(, )
#  end_location_name        :string
#  plan_type                :integer          not null
#  provider_name            :string
#  start_date               :datetime
#  start_location_latitude  :decimal(, )
#  start_location_longitude :decimal(, )
#  start_location_name      :string
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
end
