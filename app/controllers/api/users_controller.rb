# frozen_string_literal: true

module Api
  ##
  # Controller for searching for users within an autocomplete
  class UsersController < ApplicationController
    include Cacheable
    before_action :set_cache_control_headers

    def search
      trip = Trip.find(params[:trip_id])
      unless trip.present?
        head(:bad_request) and return
      end

      # Remove the "@" from the query string
      query = ActiveRecord::Base.sanitize_sql_like(params[:query].delete_prefix("@"))

      api_response = User
        .where(user_role: "member")
        .where("username LIKE ?", "%#{query}%") # Surround with "%" to find usernames that include query
        .where.not(id: trip.trip_memberships.pluck(:user_id))
        .limit(10)
        .select("id", "username")

      render(json: api_response)

      render(json: api_response)
    end
  end
end
