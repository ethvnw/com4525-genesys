# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unlock_token           :string
#  user_role              :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :bigint
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invited_by            (invited_by_type,invited_by_id)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  before_save :downcase_username
  before_save :set_default_role
  validate :password_complexity
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
    :invitable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable,
    :lockable,
    :trackable,
    :timeoutable,
    :pwned_password

  # User roles for RBAC
  enum user_role: { reporter: "Reporter", admin: "Admin", member: "Member" }

  # Ensuring username follows specific rules
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :username,
    with: /\A[a-zA-Z0-9_.]+\z/,
    message: "can only contain letters, numbers, underscores, and periods",
    multiline: true
  validates_length_of :username,
    minimum: 6,
    maximum: 20,
    message: "must be between 6 and 20 characters"

  has_one_attached :avatar
  validates :avatar,
    content_type: ["image/png", "image/jpeg"],
    size: { less_than: 5.megabytes },
    dimension: { width: { min: 32, max: 1024 }, height: { min: 32, max: 1024 } }

  has_many :trip_memberships, dependent: :destroy
  has_many :trips, through: :trip_memberships

  # Used to save the username in lowercase
  def downcase_username
    self.username = username&.downcase
  end

  # Validates the complexity of a password
  def password_complexity
    if encrypted_password_changed? && password !~ /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/
      errors.add(:password, "must contain upper and lower-case letters and numbers")
    end
  end

  def set_default_role
    self.user_role ||= self.class.user_roles[:member]
  end

  # Validates whether an invite is able to be sent (check whether role is given)
  def valid_invite?
    unless user_role.present? && User.user_roles.include?(user_role)
      errors.add(:user_role, "must be either 'Admin' or 'Reporter'")
    end
  end

  # Attribute called login to allow users to log in with either their username or email
  attr_accessor :login

  # Overrides the devise method find_for_authentication, allowing users to sign in using
  # their username or email address
  # https://stackoverflow.com/questions/2997179/ror-devise-sign-in-with-username-or-email
  class << self
    def find_for_authentication(conditions)
      login = conditions.delete(:login)
      where(conditions)
        .where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }])
        .first
    end
  end

  # Get the trips that the user is part of
  def joined_trips
    trips
      .joins(:trip_memberships)
      .where(trip_memberships: { is_invite_accepted: true })
      .distinct
  end
end
