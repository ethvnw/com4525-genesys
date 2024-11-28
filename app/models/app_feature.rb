# frozen_string_literal: true

# == Schema Information
#
# Table name: app_features
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class AppFeature < ApplicationRecord
  has_many :app_features_subscription_tiers
  has_many :subscription_tiers, through: :app_features_subscription_tiers
end
