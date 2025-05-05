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
#  referrals_count        :integer          default(0), not null
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
require "rails_helper"

RSpec.describe(User, type: :model) do
  let(:admin_user) { create(:admin) }
  let(:reporter_user) { create(:reporter) }
  let(:no_role_user) { create(:user) }

  describe "#downcase_username" do
    let(:user) { create(:user, username: "MixedCASE_Username") }

    it "saves the username in lowercase" do
      expect(user.reload.username).to(eq("mixedcase_username"))
    end
  end

  describe "username validation" do
    let(:user) { build(:user) }

    context "when username contains invalid characters" do
      it "is invalid" do
        invalid_usernames = ["user@name", "user name", "user#name!", "user-name"]

        invalid_usernames.each do |username|
          user.username = username
          expect(user).to(be_invalid)
          expect(user.errors[:username]).to(include("can only contain letters, numbers, underscores, and periods"))
        end
      end
    end

    context "when username is less than 6 characters" do
      it "is invalid" do
        user.username = "short"
        expect(user).to(be_invalid)
        expect(user.errors[:username]).to(include("must be between 6 and 20 characters"))
      end
    end

    context "when username is more than 20 characters" do
      it "is invalid" do
        user.username = "a" * 21
        expect(user).to(be_invalid)
        expect(user.errors[:username]).to(include("must be between 6 and 20 characters"))
      end
    end

    context "when username is within length limits and contains only letters, numbers, underscores, and periods" do
      it "is valid" do
        valid_usernames = ["validUsername", "user_name", "username.with.dots", "user_456"]

        valid_usernames.each do |username|
          user.username = username
          expect(user).to(be_valid)
        end
      end
    end
  end

  describe "#admin?" do
    context "when the user is an admin" do
      it "returns true" do
        expect(admin_user.admin?).to(be_truthy)
      end
    end

    context "when the user is not an admin" do
      it "returns false" do
        expect(reporter_user.admin?).to(be_falsey)
        expect(no_role_user.admin?).to(be_falsey)
      end
    end
  end

  describe "#reporter?" do
    context "when the user is a reporter" do
      it "returns true" do
        expect(reporter_user.reporter?).to(be_truthy)
      end
    end

    context "when the user is not a reporter" do
      it "returns false" do
        expect(admin_user.reporter?).to(be_falsey)
        expect(no_role_user.reporter?).to(be_falsey)
      end
    end
  end

  describe "#password_complexity" do
    let(:user) { build(:user, password: complex_password, password_confirmation: complex_password) }

    context "when the password is complex and meets the requirements" do
      context "when the password has minimum 12 chars, upper and lowercase, numbers and symbols" do
        let(:complex_password) { "AdminGenesys#1" }

        it "will not generate any errors" do
          user.valid?
          expect(user.errors[:password]).to(be_empty)
        end
      end

      context "when the password has minimum 12 chars, upper and lowercase, numbers but no symbols" do
        let(:complex_password) { "AdminGenesys1" }

        it "will not generate any errors" do
          user.valid?
          expect(user.errors[:password]).to(be_empty)
        end
      end
    end

    context "when the password is not complex and does not meeting the minimum requirements" do
      context "when the password does not meet the minimum character limit" do
        let(:complex_password) { "AdminGen#1" }

        it "an asserts that the password is too short" do
          user.valid?
          expect(user.errors[:password]).to(include("is too short (minimum is 12 characters)"))
        end
      end

      context "when the password does not contain uppercase characters" do
        let(:complex_password) { "admingenesys#1" }

        it "an asserts that the password must contain upper and lower-case letters and numbers" do
          user.valid?
          expect(user.errors[:password]).to(include("must contain upper and lower-case letters and numbers"))
        end
      end

      context "when the password does not contain lowercase characters" do
        let(:complex_password) { "ADMINGENESYS#1" }

        it "an asserts that the password must contain upper and lower-case letters and numbers" do
          user.valid?
          expect(user.errors[:password]).to(include("must contain upper and lower-case letters and numbers"))
        end
      end
    end
  end

  describe "#find_for_authentication" do
    let!(:user) { create(:user) }

    context "when logging in with a username" do
      it "finds the user by username" do
        found_user = User.find_for_authentication(login: user.username)
        expect(found_user).to(eq(user))
      end
    end

    context "when logging in with an email" do
      it "finds the user by email" do
        found_user = User.find_for_authentication(login: user.email)
        expect(found_user).to(eq(user))
      end
    end

    context "when logging in with a non-existent username or email" do
      it "returns nil" do
        found_user = User.find_for_authentication(login: "nonexistentuser")
        expect(found_user).to(be_nil)
      end
    end

    context "when login input is case-insensitive" do
      it "finds the user regardless of case" do
        found_user = User.find_for_authentication(login: user.username.upcase)
        expect(found_user).to(eq(user))

        found_user = User.find_for_authentication(login: user.email.upcase)
        expect(found_user).to(eq(user))
      end
    end
  end

  describe "#joined_trips" do
    let(:user) { create(:user) }
    let(:accepted_trip) { create(:trip) }
    let(:unaccepted_trip) { create(:trip) }
    let(:other_trip) { create(:trip) }

    before do
      create(:trip_membership, user: user, trip: accepted_trip, is_invite_accepted: true)
      create(:trip_membership, user: user, trip: unaccepted_trip, is_invite_accepted: false)

      # Ensure a trip not related to this user is not included
      create(:trip_membership, trip: other_trip, is_invite_accepted: true)
    end

    it "returns only trips where invite is accepted by user" do
      result = user.joined_trips
      expect(result).to(include(accepted_trip))
      expect(result).not_to(include(unaccepted_trip))
      expect(result).not_to(include(other_trip))
    end

    it "returns distinct trips even if multiple accepted memberships exist" do
      # Duplicate accepted membership
      create(:trip_membership, user: user, trip: accepted_trip, is_invite_accepted: true)

      result = user.joined_trips
      expect(result.count).to(eq(1))
      expect(result.first).to(eq(accepted_trip))
    end
  end
end
