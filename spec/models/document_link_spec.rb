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
require "rails_helper"

RSpec.describe(DocumentLink, type: :model) do
  pending "add some examples to (or delete) #{__FILE__}"
end
