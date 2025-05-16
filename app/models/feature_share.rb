# frozen_string_literal: true

# == Schema Information
#
# Table name: feature_shares
#
#  id              :bigint           not null, primary key
#  share_method    :string
#  created_at      :datetime         not null
#  app_feature_id  :bigint
#  registration_id :bigint
#
# Indexes
#
#  index_feature_shares_on_app_feature_id   (app_feature_id)
#  index_feature_shares_on_registration_id  (registration_id)
#
# Foreign Keys
#
#  fk_rails_...  (app_feature_id => app_features.id)
#  fk_rails_...  (registration_id => registrations.id)
#
class FeatureShare < ApplicationRecord
  belongs_to :app_feature
  belongs_to :registration
end
