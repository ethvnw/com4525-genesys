# frozen_string_literal: true

# == Schema Information
#
# Table name: landing_page_visits
#
#  id           :bigint           not null, primary key
#  country_code :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class LandingPageVisit < ApplicationRecord
  include Countable
  class << self
    def count_by_country
      LandingPageVisit.all
        .group_by(&:country_code)
        .transform_keys { |code| ISO3166::Country.new(code) }
        .transform_values(&:count)
    end
  end
end
