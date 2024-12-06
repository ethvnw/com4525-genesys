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
  class << self
    def by_day
      LandingPageVisit.all.group_by do |visit|
        visit.created_at.beginning_of_day
      end.transform_values(&:count)
    end

    def by_week
      LandingPageVisit.all.group_by do |visit|
        visit.created_at.beginning_of_week
      end.transform_values(&:count)
    end

    def by_month
      LandingPageVisit.all.group_by do |visit|
        visit.created_at.beginning_of_month
      end.transform_values(&:count)
    end

    def by_country
      LandingPageVisit.all
        .group_by(&:country_code)
        .transform_keys { |code| ISO3166::Country.new(code) }
        .transform_values { |registrations| registrations.count }
    end
  end
end
