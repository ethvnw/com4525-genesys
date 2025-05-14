# frozen_string_literal: true

require "rails_helper"

RSpec.describe(PlanDecorator, type: :decorator) do
  before do
    travel_to Time.zone.parse("2000-01-01 1:00:00")
  end

  let(:plan) { create(:plan, start_date: Time.current, end_date: Time.current + 1.hour) }
  let(:decorated_plan) { plan.decorate }

  describe "#single_day?" do
    context "when the plan starts and ends on the same day" do
      it "returns true" do
        expect(decorated_plan.single_day?).to(be(true))
      end
    end
    context "when the plan starts and ends on different days" do
      before { decorated_plan.end_date = Time.current + 1.day }

      it "returns false" do
        expect(decorated_plan.single_day?).to(be(false))
      end
    end
  end

  describe "#formatted_date_range" do
    context "when the end date is present" do
      it "returns the start and end time as 'start to end'" do
        expect(decorated_plan.formatted_date_range).to(eq("01:00 - 02:00, 01 Jan 2000"))
      end

      it "shows start and end month if they differ" do
        decorated_plan.end_date = Time.current + 1.month + 1.hour
        expect(decorated_plan.formatted_date_range).to(eq("01:00, 01 Jan - 02:00, 01 Feb 2000"))
      end

      it "shows start and end year if they differ" do
        decorated_plan.end_date = Time.current + 1.year + 1.hour
        expect(decorated_plan.formatted_date_range).to(eq("01:00, 01 Jan 2000 - 02:00, 01 Jan 2001"))
      end
    end

    context "when the end date is not present" do
      before { decorated_plan.end_date = nil }

      it "returns the start date and time" do
        expect(decorated_plan.formatted_date_range).to(eq("01:00, 01 Jan 2000"))
      end
    end
  end

  describe "#formatted_end_date" do
    context "when the end date is the same day as the start date" do
      it "returns the end time as 'HH:MM'" do
        expect(decorated_plan.formatted_end_date).to(eq("02:00"))
      end
    end

    context "when the end date is not the same day as the start date" do
      before { decorated_plan.end_date = Time.zone.now + 1.day }

      it "returns the end date as 'DD Month YYYY, HH:MM'" do
        expect(decorated_plan.formatted_end_date).to(eq("02 January 2000, 01:00"))
      end
    end

    context "when the end date is not present" do
      before { decorated_plan.end_date = nil }

      it "returns 'No end date'" do
        expect(decorated_plan.formatted_end_date).to(eq("No end date"))
      end
    end
  end

  describe "#travel_icon" do
    context "when the plan type is 'travel_by_plane'" do
      before { decorated_plan.plan_type = "travel_by_plane" }

      it "returns the airplane icon" do
        expect(decorated_plan.travel_icon).to(eq("bi bi-airplane-fill"))
      end
    end

    context "when the plan type is 'travel_by_train'" do
      before { decorated_plan.plan_type = "travel_by_train" }

      it "returns the train icon" do
        expect(decorated_plan.travel_icon).to(eq("bi bi-train-front-fill"))
      end
    end

    context "when the plan type is 'travel_by_bus'" do
      before { decorated_plan.plan_type = "travel_by_bus" }

      it "returns the bus icon" do
        expect(decorated_plan.travel_icon).to(eq("bi bi-bus-front-fill"))
      end
    end

    context "when the plan type is 'travel_by_car'" do
      before { decorated_plan.plan_type = "travel_by_car" }

      it "returns the car icon" do
        expect(decorated_plan.travel_icon).to(eq("bi bi-car-front-fill"))
      end
    end

    context "when the plan type is 'travel_by_boat'" do
      before { decorated_plan.plan_type = "travel_by_boat" }

      it "returns the boat icon" do
        expect(decorated_plan.travel_icon).to(eq("bi bi-water"))
      end
    end

    context "when the plan type is 'travel_by_foot'" do
      before { decorated_plan.plan_type = "travel_by_foot" }

      it "returns the walking icon" do
        expect(decorated_plan.travel_icon).to(eq("bi bi-person-walking"))
      end
    end

    context "when the plan type is not a travel type" do
      before { decorated_plan.plan_type = "restaurant" }

      it "returns the question mark icon" do
        expect(decorated_plan.travel_icon).to(eq("bi bi-question-circle-fill"))
      end
    end
  end

  describe "#view_icon" do
    context "when the plan type is 'clubbing'" do
      before { decorated_plan.plan_type = "clubbing" }

      it "returns the ticket icon" do
        expect(decorated_plan.view_icon).to(eq("bi-ticket-detailed-fill"))
      end
    end

    context "when the plan type is 'live_music'" do
      before { decorated_plan.plan_type = "live_music" }

      it "returns the ticket icon" do
        expect(decorated_plan.view_icon).to(eq("bi-ticket-detailed-fill"))
      end
    end

    context "when the plan type is a travel plan" do
      before { decorated_plan.plan_type = "travel_by_boat" }

      it "returns the ticket icon" do
        expect(decorated_plan.view_icon).to(eq("bi-ticket-detailed-fill"))
      end
    end

    context "when the plan type is 'restaurant'" do
      before { decorated_plan.plan_type = "restaurant" }

      it "returns the bookmark icon" do
        expect(decorated_plan.view_icon).to(eq("bi-bookmark-dash-fill"))
      end
    end

    context "when the plan type is 'entertainment'" do
      before { decorated_plan.plan_type = "entertainment" }

      it "returns the smiley face icon" do
        expect(decorated_plan.view_icon).to(eq("bi-emoji-smile-fill"))
      end
    end

    context "when the plan type is 'wellness'" do
      before { decorated_plan.plan_type = "wellness" }

      it "returns the heart icon" do
        expect(decorated_plan.view_icon).to(eq("bi-heart-pulse-fill"))
      end
    end

    context "when the plan type is 'active'" do
      before { decorated_plan.plan_type = "active" }

      it "returns the person icon" do
        expect(decorated_plan.view_icon).to(eq("bi-person-arms-up"))
      end
    end

    context "when the plan type is 'sightseeing'" do
      before { decorated_plan.plan_type = "sightseeing" }

      it "returns the camera icon" do
        expect(decorated_plan.view_icon).to(eq("bi-camera-fill"))
      end
    end

    context "when the plan type is not a known type" do
      before { decorated_plan.plan_type = "other" }

      it "returns the receipt icon" do
        expect(decorated_plan.view_icon).to(eq("bi-receipt"))
      end
    end
  end

  describe "#view_label" do
    context "when the plan type is 'clubbing'" do
      before { decorated_plan.plan_type = "clubbing" }

      it "returns 'View Tickets'" do
        expect(decorated_plan.view_label).to(eq("View Tickets"))
      end
    end

    context "when the plan type is 'live_music'" do
      before { decorated_plan.plan_type = "live_music" }

      it "returns 'View Tickets'" do
        expect(decorated_plan.view_label).to(eq("View Tickets"))
      end
    end

    context "when the plan type is 'entertainment'" do
      before { decorated_plan.plan_type = "entertainment" }

      it "returns 'View Tickets'" do
        expect(decorated_plan.view_label).to(eq("View Tickets"))
      end
    end

    context "when the plan type is a travel plan" do
      before { decorated_plan.plan_type = "travel_by_boat" }

      it "returns 'View Tickets'" do
        expect(decorated_plan.view_label).to(eq("View Tickets"))
      end
    end

    context "when the plan type is 'restaurant'" do
      before { decorated_plan.plan_type = "restaurant" }

      it "returns 'View Reservation'" do
        expect(decorated_plan.view_label).to(eq("View Reservation"))
      end
    end

    context "when the plan type is not a known type" do
      before { decorated_plan.plan_type = "other" }

      it "returns 'View Plan'" do
        expect(decorated_plan.view_label).to(eq("View Plan"))
      end
    end
  end
end
