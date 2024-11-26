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
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unlock_token           :string
#  user_role              :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  validate :password_complexity
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable,
    :lockable,
    :trackable,
    :timeoutable,
    :pwned_password

  enum user_role: { reporter: "Reporter", admin: "Admin" }

  # Validates the complexity of a password
  def password_complexity
    if encrypted_password_changed? && password !~ /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/
      errors.add(:password, "must contain upper and lower-case letters and numbers")
    end
  end

  # If the last sign in is <nil> but an account exists,
  # then an admin created the account but the user hasn't registered
  def account_activated?
    !last_sign_in_at.nil?
  end

  # Show the user role formatted with uppercase
  def show_role
    user_role.titleize
  end
end
