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
class TicketLink < ApplicationRecord
  belongs_to :plan, counter_cache: true
end
