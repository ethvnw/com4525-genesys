# frozen_string_literal: true

# == Schema Information
#
# Table name: reviews
#
#  id                 :bigint           not null, primary key
#  content            :text
#  engagement_counter :integer
#  is_hidden          :boolean
#  name               :string
#  order              :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :review do
    content { "MyText" }
    order { 1 }
    is_hidden { false }
    engagement_counter { 1 }
  end
end
