# frozen_string_literal: true

# == Schema Information
#
# Table name: document_links
#
#  id            :bigint           not null, primary key
#  document_link :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  plan_id       :bigint
#
# Indexes
#
#  index_document_links_on_plan_id  (plan_id)
#
FactoryBot.define do
  factory :document_link do
  end
end
