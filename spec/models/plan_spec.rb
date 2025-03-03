# frozen_string_literal: true

# == Schema Information
#
# Table name: plans
#
#  id                  :bigint           not null, primary key
#  end_date            :datetime
#  end_location_lat    :decimal(, )
#  end_location_lng    :decimal(, )
#  end_location_name   :string
#  start_date          :datetime
#  start_location_lat  :decimal(, )
#  start_location_lng  :decimal(, )
#  start_location_name :string
#  title               :string           not null
#  type                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  trip_id             :bigint
#
# Indexes
#
#  index_plans_on_trip_id  (trip_id)
#
require "rails_helper"

RSpec.describe(Plan, type: :model) do
  pending "add some examples to (or delete) #{__FILE__}"
end
