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
require "rails_helper"

RSpec.describe(User, type: :model) do
  describe "#account_activated?" do
    let(:user) { build(:user, last_sign_in_at: time) }

    context "when last_sign_in_at is nil" do
      let(:time) { nil }

      it "returns false that the account is not activated" do
        expect(user.account_activated?).to(be_falsey)
      end
    end

    context "when last_sign_in_at is timestamped" do
      let(:time) { Time.current }

      it "returns true that the account has been activated" do
        expect(user.account_activated?).to(be_truthy)
      end
    end
  end

  describe "#show_role" do
    let(:user) { build(:user, user_role: role) }

    context "when the user is an admin" do
      let(:role) { :admin }

      it "correctly formats the role name" do
        expect(user.show_role).to(eq("Admin"))
        expect(user.show_role).not_to(eq("admin"))
      end
    end

    context "when the user is an reporter" do
      let(:role) { :reporter }

      it "correctly formats the role name" do
        expect(user.show_role).to(eq("Reporter"))
        expect(user.show_role).not_to(eq("reporter"))
      end
    end
  end

  describe "access rights" do
    let(:user) { build(:user, user_role: role) }

    context "when the user is an admin" do
      let(:role) { :admin }

      it "returns true that the user is an admin" do
        expect(user.admin?).to(be_truthy)
        expect(user.reporter?).to(be_falsey)
      end
    end

    context "when the user is an reporter" do
      let(:role) { :reporter }

      it "returns true that the user is a reporter" do
        expect(user.reporter?).to(be_truthy)
        expect(user.admin?).to(be_falsey)
      end
    end

    context "when the user has no role" do
      let(:role) { nil }

      it "admin authorisation returns false" do
        expect(user.admin?).to(be_falsey)
      end

      it "reporter authorisation returns false" do
        expect(user.reporter?).to(be_falsey)
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
end
