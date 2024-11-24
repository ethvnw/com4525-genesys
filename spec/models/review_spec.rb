# frozen_string_literal: true

# == Schema Information
#
# Table name: reviews
#
#  id                 :bigint           not null, primary key
#  content            :text
#  engagement_counter :integer          default(0)
#  is_hidden          :boolean          default(TRUE)
#  name               :string
#  order              :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require "rails_helper"

RSpec.describe(Review, type: :model) do
  pending "add some examples to (or delete) #{__FILE__}"
end
