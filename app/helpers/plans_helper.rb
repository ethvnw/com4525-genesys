# frozen_string_literal: true

# Module containing helper methods for plans
module PlansHelper
  # Set the value of the hidden field for booking references
  def booking_reference_value(param_data, plan)
    param_data.presence || plan.booking_references.map do |br|
      { name: br.name, number: br.reference_number }
    end.to_json
  end

  def ticket_link_value(param_data, plan)
    param_data.presence || plan.ticket_links.map do |tl|
      { name: tl.name, url: tl.link }
    end.to_json
  end
end
