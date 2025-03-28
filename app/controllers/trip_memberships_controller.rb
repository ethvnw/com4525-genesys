# frozen_string_literal: true

# Handles trip memberships
class TripMembershipsController < ApplicationController
  layout "user"
  before_action :authenticate_user!

  def index
    @trip = Trip.find(params[:trip_id])
    members = @trip.trip_memberships
    @members = members.select { |m| m.is_invite_accepted }
    @pending_members = members.select { |m| !m.is_invite_accepted }
  end

  def destroy
    trip_membership = TripMembership.find(params[:id])
    trip_membership.destroy
    redirect_to(trip_trip_memberships_path, notice: "User removed successfully.")
  end

  def create
  end
end