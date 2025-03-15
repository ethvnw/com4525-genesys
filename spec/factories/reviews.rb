# frozen_string_literal: true

# == Schema Information
#
# Table name: reviews
#
#  id                 :bigint           not null, primary key
#  content            :text
#  engagement_counter :integer          default(0)
#  is_hidden          :boolean          default(TRUE)
#  name               :string(50)
#  order              :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :review do
    name { "MyName" }
    content { "MyContent" }
    order { 0 }
    is_hidden { false }
    engagement_counter { 0 }
  end
end
