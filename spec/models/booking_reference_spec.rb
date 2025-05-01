# frozen_string_literal: true

# == Schema Information
#
# Table name: booking_references
#
#  id                :bigint           not null, primary key
#  booking_reference :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  plan_id           :bigint           not null
#
# Indexes
#
#  index_booking_references_on_plan_id  (plan_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#
require "rails_helper"

RSpec.describe(BookingReference, type: :model) do
  pending "add some examples to (or delete) #{__FILE__}"
end
