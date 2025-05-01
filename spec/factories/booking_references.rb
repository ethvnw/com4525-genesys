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
FactoryBot.define do
  factory :booking_reference do
    booking_reference { "MyString" }
    plan { nil }
  end
end
