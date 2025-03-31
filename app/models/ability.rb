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

    unless user.member?
      can(:access, [:landing, :faq, :subscription])
    end

    can(:read, SubscriptionTier)
    can(:read, Question, is_hidden: false)
    can(:read, Review, is_hidden: false)

    # Allowing user to view a trip only if they are a member of that trip and accepted invite
    can(:read, Trip) do |trip|
      trip.trip_memberships.exists?(user_id: user.id, is_invite_accepted: true)
    end

    # Allowing user to view a plan only if they are a member of that trip and accepted invite
    can(:read, Plan) do |plan|
      plan.trip.trip_memberships.exists?(user_id: user.id, is_invite_accepted: true)
    end

    # Allowing user to manage a trip only if they are a member of that trip and accepted invite
    can(:manage, TripMembership) do |membership|
      membership.trip.trip_memberships.exists?(user_id: user.id, is_invite_accepted: true)
    end
  end
end
