# frozen_string_literal: true

# == Schema Information
#
# Table name: referrals
#
#  id             :bigint           not null, primary key
#  receiver_email :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  sender_user_id :bigint           not null
#
# Indexes
#
#  index_referrals_on_sender_user_id  (sender_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (sender_user_id => users.id)
#
class Referral < ApplicationRecord
  belongs_to :sender_user, class_name: "User", foreign_key: "sender_user_id"
end
