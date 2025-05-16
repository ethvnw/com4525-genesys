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
class ScannableTicket < ApplicationRecord
  belongs_to :plan, counter_cache: true

  enum ticket_format: [:qr, :code_39, :code_128]

  validates :ticket_format, inclusion: { in: ticket_formats }
  validates :title, presence: true
end
