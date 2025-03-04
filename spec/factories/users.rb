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

FactoryBot.define do
  factory :user do
    username { "MockUser" }
    email { "test@epigenesys.org.uk" }
    password { "GenesysModule#1" }
    password_confirmation { "GenesysModule#1" }

    avatar do
      Rack::Test::UploadedFile.new(
        File.join(Rails.root, "spec", "support", "files", "mock_avatar.png"),
        "image/png",
      )
    end
  end

  factory :admin, class: User do
    username { "MockAdmin" }
    email { "admin@epigenesys.org.uk" }
    password { "GenesysModule#1" }
    password_confirmation { "GenesysModule#1" }
    user_role { "admin" }
    avatar do
      Rack::Test::UploadedFile.new(
        File.join(Rails.root, "spec", "support", "files", "mock_avatar.png"),
        "image/png",
      )
    end
  end

  factory :reporter, class: User do
    username { "MockReporter" }
    email { "reporter@epigenesys.org.uk" }
    password { "GenesysModule#1" }
    password_confirmation { "GenesysModule#1" }
    user_role { "reporter" }
    avatar do
      Rack::Test::UploadedFile.new(
        File.join(Rails.root, "spec", "support", "files", "mock_avatar.png"),
        "image/png",
      )
    end
  end
end
