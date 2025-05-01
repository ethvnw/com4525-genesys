# frozen_string_literal: true

# == Schema Information
#
# Table name: ticket_links
#
#  id         :bigint           not null, primary key
#  link       :string           not null
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plan_id    :bigint
#
# Indexes
#
#  index_ticket_links_on_plan_id  (plan_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#
FactoryBot.define do
  factory :ticket_link do
    link { "https://example.com/ticket" }
    name { "Example Ticket" }
    association :plan
  end
end
