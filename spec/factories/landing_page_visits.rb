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
FactoryBot.define do
  factory :landing_page_visit do
    country_code_iso { "GB" }
  end
end
