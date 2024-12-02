# == Schema Information
#
# Table name: registrations
#
#  id                   :bigint           not null, primary key
#  country_code         :string
#  email                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  subscription_tier_id :bigint           not null
#
# Indexes
#
#  index_registrations_on_subscription_tier_id  (subscription_tier_id)
#
# Foreign Keys
#
#  fk_rails_...  (subscription_tier_id => subscription_tiers.id)
#
require 'rails_helper'

RSpec.describe Registration, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
