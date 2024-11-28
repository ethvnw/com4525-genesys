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
FactoryBot.define do
  factory :app_feature do
    name { "MyString" }
    description { "MyText" }
  end
end
