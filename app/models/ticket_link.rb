# frozen_string_literal: true

# == Schema Information
#
# Table name: ticket_links
#
#  id          :bigint           not null, primary key
#  ticket_link :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  plan_id     :bigint
#
# Indexes
#
#  index_ticket_links_on_plan_id  (plan_id)
#
class TicketLink < ApplicationRecord
  belongs_to :plan
end
