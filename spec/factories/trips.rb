# frozen_string_literal: true

# == Schema Information
#
# Table name: trips
#
#  id                 :bigint           not null, primary key
#  description        :string
#  end_date           :datetime
#  location_latitude  :decimal(, )
#  location_longitude :decimal(, )
#  location_name      :string
#  start_date         :datetime
#  title              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  ##
  factory :trip do
    title { "Mock Trip" }
    description { "Mock Trip Description" }

    start_date { Time.current }
    end_date { Time.current + 1.day }

    location_name { "The Peak District" }
    location_latitude { 53.3673 }
    location_longitude { 1.8158 }

    image do
      Rack::Test::UploadedFile.new(
        File.join(Rails.root, "spec", "support", "files", "mock_trip_image.jpg"),
        "image/jpeg",
      )
    end
  end
end
