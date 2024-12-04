# frozen_string_literal: true

##
# Controller for features, handling sharing
class FeaturesController < ApplicationController
  SHARERS = {
    "email" => Sharing::EmailSharer,
    "facebook" => Sharing::FacebookSharer,
    "twitter" => Sharing::TwitterSharer,
    "whatsapp" => Sharing::WhatsappSharer,
  }.freeze

  # GET /api/features/:id/share/:method
  def share_feature
    sharer = SHARERS.fetch(params[:method].to_s, nil)

    if sharer.present? && AppFeature.exists?(id: params[:id])
      redirect_to(sharer.call(AppFeature.find_by_id(params[:id])), allow_other_host: true)
    else
      head(:not_found)
    end
  end
end
