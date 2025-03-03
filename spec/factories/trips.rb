# frozen_string_literal: true

# == Schema Information
#
# Table name: trips
#
#  id            :bigint           not null, primary key
#  description   :string
#  end_date      :datetime
#  location_lat  :decimal(, )
#  location_lng  :decimal(, )
#  location_name :string
#  start_date    :datetime
#  title         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :trip do
  end
end
