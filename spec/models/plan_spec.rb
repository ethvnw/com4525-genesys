# frozen_string_literal: true

# == Schema Information
#
# Table name: plans
#
#  id                       :bigint           not null, primary key
#  end_date                 :datetime
#  end_location_latitude    :decimal(, )
#  end_location_longitude   :decimal(, )
#  end_location_name        :string
#  plan_type                :integer          not null
#  provider_name            :string
#  start_date               :datetime
#  start_location_latitude  :decimal(, )
#  start_location_longitude :decimal(, )
#  start_location_name      :string
#  title                    :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  trip_id                  :bigint
#
# Indexes
#
#  index_plans_on_trip_id  (trip_id)
#
require "rails_helper"
require_relative "../concerns/countable_shared_examples"

RSpec.describe(Plan, type: :model) do
  it_behaves_like "countable"
end
