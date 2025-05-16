# frozen_string_literal: true

# Handles trip memberships
class TripMembershipsController < ApplicationController
  include Streamable
  before_action :authenticate_user!
  before_action :restrict_admin_and_reporter_access!

  load_and_authorize_resource :trip, except: [:accept_invite, :decline_invite]
  load_and_authorize_resource :trip_membership, through: :trip, except: [:accept_invite, :decline_invite]

  layout "user"

  def index
    @script_packs = ["trip_memberships"]

    @trip_membership = TripMembership.new
    @errors = flash[:errors]

    @trip = Trip.includes(trip_memberships: { user: { avatar_attachment: :blob } }).find(params[:trip_id])
    @members = @trip.trip_memberships.where(is_invite_accepted: true).order(invite_accepted_date: :desc).decorate
    @pending_members = @trip.trip_memberships.where(is_invite_accepted: false).order(created_at: :desc).decorate
  end

  def destroy
    trip_membership = TripMembership.find(params[:id])
    user = trip_membership.user
    trip_membership.destroy

    if user == current_user
      redirect_to(trips_path, notice: "You have left the trip.")
    else
      redirect_to(trip_trip_memberships_path, notice: "User removed successfully.")
    end
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
    trip_membership = TripMembership.find(params[:id])
    authorize!(:respond_invite, trip_membership)

    trip_membership.update!(
      is_invite_accepted: true,
      invite_accepted_date: Time.current,
      user_display_name: current_user.username,
    )

    redirect_to(inbox_path, notice: "Invite accepted successfully.")
  end

  def decline_invite
    trip_membership = TripMembership.find(params[:id])
    authorize!(:respond_invite, trip_membership)

    trip_membership.destroy
    redirect_to(inbox_path, notice: "Invite declined successfully.")
  end

  def update
    @trip_membership = TripMembership.find(params[:id])
    if @trip_membership.update(trip_membership_params)
      redirect_to(trip_path(@trip_membership.trip), notice: "Display name updated successfully.")
    else
      flash[:errors] = @trip_membership.errors.to_hash(true)
      stream_response("trip_memberships/update", trip_path(@trip_membership.trip))
    end
  end

  private

  def trip_membership_params
    params.require(:trip_membership).permit(
      :username,
      :user_display_name,
    )
  end
end
