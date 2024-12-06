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
require "rails_helper"

RSpec.describe(LandingPageVisit, type: :model) do
  pending "add some examples to (or delete) #{__FILE__}"
end
