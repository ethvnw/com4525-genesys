# frozen_string_literal: true

# == Schema Information
#
# Table name: featured_locations
#
#  id               :bigint           not null, primary key
#  country_code_iso :string
#  latitude         :decimal(, )
#  longitude        :decimal(, )
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class FeaturedLocation < ApplicationRecord
  has_one_attached :image
end
