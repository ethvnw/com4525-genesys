# frozen_string_literal: true

# CanCanCan ability class, controlling authorisation
class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the user here. For example:
    #
    #   return unless user.present?
    #   can :read, :all
    #   return unless user.admin?
    #   can :manage, :all
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

    # Guest user (not logged in)
    user ||= User.new

    if user.admin?
      can(:manage, :all)
    end

    if user.reporter?
      can(:access, :reporter_dashboard)
      can(:read, Registration)
    end

    if user.admin? || user.reporter?
      cannot(:manage, Trip)
      cannot(:manage, Plan)
      cannot(:manage, TripMembership)
    end

    if user.admin? || user.reporter?
      cannot(:access, :home)
    end

    unless user.member?
      can(:access, [:landing, :faq, :subscription])
    end

    can(:read, SubscriptionTier)
    can(:read, Question, is_hidden: false)
    can(:read, Review, is_hidden: false)

    # Anyone can create a trip
    can(:create, Trip)

    # Allowing user to manage a trip only if they are a member of that trip and accepted invite
    can(:manage, Trip) do |trip|
      trip.trip_memberships.exists?(user_id: user.id, is_invite_accepted: true)
    end

    # Allowing user to manage a plan only if they are a member of that trip and accepted invite
    can(:manage, Plan) do |plan|
      plan.trip.trip_memberships.exists?(user_id: user.id, is_invite_accepted: true)
    end

    # Allowing user to create a TripMembership only if they are a member of the trip and accepted the invite
    can(:create, TripMembership) do |membership|
      membership.trip.trip_memberships.exists?(user_id: user.id, is_invite_accepted: true)
    end

    # Allowing user to read a TripMembership only if they are a member of the trip and accepted the invite
    can(:read, TripMembership) do |membership|
      membership.trip.trip_memberships.exists?(user_id: user.id, is_invite_accepted: true)
    end

    # Allowing user to update a TripMembership only if they are the user associated with the membership
    can(:update, TripMembership) do |membership|
      membership.user == user
    end

    # Allowing user to accept/decline a TripMembership invite only if they have been invited & not actioned it
    can(:respond_invite, TripMembership) do |membership|
      membership.trip.trip_memberships.exists?(user_id: user.id, is_invite_accepted: false)
    end

    # Allowing user to destroy a TripMembership only if they are a member of the trip and accepted the invite
    can(:destroy, TripMembership) do |membership|
      membership.trip.trip_memberships.exists?(user_id: user.id, is_invite_accepted: true)
    end
  end
end
