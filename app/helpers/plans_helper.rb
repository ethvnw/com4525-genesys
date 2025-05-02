# frozen_string_literal: true

# Module containing helper methods for plans
module PlansHelper
  # Whilst it would've been nice to have these as a single method, the structure of ticket links and
  # booking references are different, impacting both retrieval and creation.

  # Returns the booking reference data in JSON format.
  #
  # If `param_data` is present, it is returned as is. Otherwise, it constructs
  # a JSON representation of the existing booking references associated with the plan.
  #
  # @param param_data [String, nil]: the booking value data stored in params, which loads data for incomplete plans.
  # @param plan [Plan]: the plan object, loading booking references whilst editing already complete plans.
  # @return [String]: JSON representation of booking references.
  def booking_reference_value(param_data, plan)
    param_data.presence || plan.booking_references.map do |br|
      { name: br.name, number: br.reference_number }
    end.to_json
  end

  # Returns the ticket link data in JSON format.
  #
  # If `param_data` is present, it is returned as is. Otherwise, it constructs
  # a JSON representation of the existing ticket links associated with the plan.
  #
  # ticket_link_value is used to load the existing ticket link data for the plan
  # @param param_data [String, nil]: the ticket link data stored in params, which loads data for incomplete plans
  # @param plan [Plan]: the plan object, loading ticket links whilst editing already complete plans
  # @return [String]: JSON representation of ticket links.
  def ticket_link_value(param_data, plan)
    param_data.presence || plan.ticket_links.map do |tl|
      { name: tl.name, url: tl.link }
    end.to_json
  end

  ##
  # Renders the appropriate plan partial based on the plan type.
  #
  ## @param plan [Plan]: the plan object to be rendered
  # @param trip [Trip]: the trip object associated with the plan
  def render_plan_partial(plan, trip)
    if plan.travel_plan?
      render("partials/plans/travel_card", trip: trip, plan: plan)
    else
      render("partials/plans/event_card", trip: trip, plan: plan)
    end
  end
end
