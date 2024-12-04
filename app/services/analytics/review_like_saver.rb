# frozen_string_literal: true

module Analytics
  ##
  # Analytics saver for review likes
  class ReviewLikeSaver < JourneySaver
    def call
      @journey.each do |review_like|
        ReviewLike.create(
          registration_id: @registration_id,
          review_id: review_like[:id],
        )
      end
    end
  end
end
