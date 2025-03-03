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
require "rails_helper"

RSpec.describe(Trip, type: :model) do
  pending "add some examples to (or delete) #{__FILE__}"
end
