# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id                 :bigint           not null, primary key
#  answer             :text
#  engagement_counter :integer
#  is_hidden          :boolean
#  question           :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require "rails_helper"

RSpec.describe(Question, type: :model) do
  pending "add some examples to (or delete) #{__FILE__}"
end
