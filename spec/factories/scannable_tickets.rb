# frozen_string_literal: true

# == Schema Information
#
# Table name: scannable_tickets
#
#  id            :bigint           not null, primary key
#  code          :string           not null
#  ticket_format :integer          not null
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  plan_id       :bigint
#
# Indexes
#
#  index_scannable_tickets_on_plan_id  (plan_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#
FactoryBot.define do
  factory :scannable_ticket do
    code { "Mock ticket code" }
    ticket_format { :qr }
    title { "Mock ticket title" }
    association :plan
  end
end
