# frozen_string_literal: true

# == Schema Information
#
# Table name: feature_shares
#
#  id              :bigint           not null, primary key
#  share_method    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  app_feature_id  :bigint
#  registration_id :bigint
#
# Indexes
#
#  index_feature_shares_on_app_feature_id   (app_feature_id)
#  index_feature_shares_on_registration_id  (registration_id)
#
FactoryBot.define do
  factory :feature_share do
    share_method { "email" }
    association :app_feature
    association :registration
  end
end
