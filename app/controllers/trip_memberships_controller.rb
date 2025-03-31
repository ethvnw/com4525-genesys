# frozen_string_literal: true

# Handles trip memberships
class TripMembershipsController < ApplicationController
  include Streamable

  layout "user"
  before_action :authenticate_user!
  before_action :authorize_trip_memberships, only: [:index]

  def index
    @script_packs = ["trip_memberships"]

    @trip_membership = TripMembership.new
    @errors = flash[:errors]

    @trip = Trip.find(params[:trip_id])
    members = @trip.trip_memberships.map { |member| TripMembershipDecorator.new(member, current_user) }
    @members = members.select(&:is_invite_accepted)
    @pending_members = members.reject(&:is_invite_accepted)

    # Options for the user search functionality; excludes staff/reporters and users already present
    @users = User.where(user_role: "member").where.not(id: @trip.trip_memberships.pluck(:user_id)).select(
      :id,
      :username,
    )
  end

  def destroy
    trip_membership = TripMembership.find(params[:id])
    trip_membership.destroy
    redirect_to(trip_trip_memberships_path, notice: "User removed successfully.")
  end

  def create
    @trip_membership = TripMembership.new(trip_membership_params)
    @trip_membership.trip = Trip.find(params[:trip_id])
    @trip_membership.user = User.find_by(username: @trip_membership.username)
    @trip_membership.sender_user_id = current_user.id

    if @trip_membership.save
      TripMembershipMailer.invite_user(@trip_membership).deliver_later
      redirect_to(trip_trip_memberships_path, notice: "User invited successfully.")
    else
      @users = User.where(user_role: "member").where.not(
        id: @trip_membership.trip.trip_memberships.pluck(:user_id),
      ).select(:id, :username)
      flash[:errors] = @trip_membership.errors.to_hash(true)

      if @trip_membership.errors[:base].any?
        respond_with_toast(
          { type: "danger", content: @trip_membership.errors[:base].first },
          trip_trip_memberships_path,
        )
      else
        stream_response("trip_memberships/create", trip_trip_memberships_path(@trip_membership.trip))
      end
    end
  end

  def accept_invite
    @trip_membership = TripMembership.find(params[:id])
    @trip_membership.is_invite_accepted = true
    @trip_membership.user_display_name = current_user.username
    @trip_membership.save
    redirect_to(inbox_path, notice: "Invite accepted successfully.")
  end

  def decline_invite
    @trip_membership = TripMembership.find(params[:id])
    @trip_membership.destroy
    redirect_to(inbox_path, notice: "Invite declined successfully.")
  end

  private

  def trip_membership_params
    params.require(:trip_membership).permit(
      :username,
    )
  end

  def authorize_trip_memberships
    trip = Trip.find(params[:trip_id])
    unless can?(:manage, trip) && can?(:manage, TripMembership)
      raise CanCan::AccessDenied.new(
        "You are not authorized to manage this trip's members.",
        :manage,
        trip.trip_memberships,
      )
    end
  end
end
