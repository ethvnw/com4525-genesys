# frozen_string_literal: true

# == Schema Information
#
# Table name: app_features
#
#  id                 :bigint           not null, primary key
#  description        :text
#  engagement_counter :integer          default(0), not null
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :app_feature do
    name { "App Feature" }
    description { "A feature" }
    engagement_counter { 0 }
  end
end
