# frozen_string_literal: true

# Module containing global helper functions
module ApplicationHelper
  ##
  # Converts a list of script pack names into a list of paths
  # Will return an empty list if `script_packs` is nil
  # @param script_packs [Array<String>] an array of script pack names
  # @return [Array<String>] an array of script pack paths
  def get_script_paths(script_packs)
    if script_packs.present?
      script_packs.map { |script_pack| "scriptpacks/#{script_pack}" }
    else
      []
    end
  end

  ##
  # Converts a list of style pack names into a list of paths
  # Will return an empty list if `style_packs` is nil
  # @param style_packs [Array<String>] an array of style pack names
  # @return [Array<String>] an array of style pack paths
  def get_style_paths(style_packs)
    if style_packs.present?
      style_packs.map { |style_pack| "stylepacks/#{style_pack}" }
    else
      []
    end
  end

  ##
  # Generates a navbar link with an icon and text
  # Highlights the link if the provided route matches the current route
  # @param name [String] the text to display for the link
  # @param icon [String] the Bootstrap icon class to use
  # @param path [String] the route for the link
  # @param badge_count [Integer] (optional) The number to display as a badge
  # @return [String] a Bootstrap HTML element containing the link
  def navbar_link_to(name, icon, path, badge_count = 0)
    content_tag(:li, class: "nav-item") do
      link_to(path, class: "#{"active" if current_page?(path)} nav-link") do
        concat(
          content_tag(:div, class: "position-relative") do
            concat(content_tag(:i, nil, class: "#{current_page?(path) ? "#{icon}-fill" : icon} bi"))
            if badge_count&.nonzero?
              concat(content_tag(:div, badge_count, class: "nav-badge"))
            end
          end,
        )
        concat(content_tag(:span, name, class: "text-center"))
        if badge_count&.nonzero?
          concat(content_tag(:div, badge_count, class: "nav-badge-lg"))
        end
      end
    end
  end

  ##
  # Generates a link which adds query parameters to the current path.
  # Useful for changing from map to list view, or for sorting.
  # @param key [Symbol] the key of the new parameter
  # @param value [String] the value of the new parameter
  # @param icon [String] the Bootstrap icon class to use
  # @return [String] an HTML element containing the link
  #
  # @example Switching to map view (will add `view=map` to query parameters)
  #   = add_param_button(:view, "map", "bi-pin-map")
  #
  def add_param_button(key, value, icon)
    link_to(
      url_for(request.query_parameters.merge({ key => value })),
      class: "#{"active " if params[key] == value}change-view-link",
      data: { turbo: "true" },
    ) do
      concat(content_tag(:i, nil, class: "#{icon} bi"))
      concat(content_tag(:span, value.humanize))
    end
  end

  ##
  # Retrieves and formats error messages for a specific form field
  # @param errors [Hash] the hash containing validation errors, generated with record.errors.to_hash(true)
  # @param key [Symbol] the field key to get errors for
  # @return [String, nil] joined error messages for the field (or nil if no errors)
  def get_formatted_errors(errors, key)
    errors ||= {}
    errors_for_key = errors[key]

    if errors_for_key.present?
      errors_for_key.join("\n")
    end
  end

  ##
  # Determines the Bootstrap validation class based on field errors
  # @param errors [Hash] the errors hash containing validation errors
  # @param key [Symbol] the field key to check for errors
  # @return [String, nil] 'is-invalid' if field has errors, 'is-valid' if errors exist but this field is valid,
  #                       nil otherwise
  def get_error_class_with(errors, key)
    if errors.present?
      if errors.include?(key) && errors[key].present?
        "is-invalid"
      else
        "is-valid"
      end
    end
  end

  ##
  # Renders a form error message in a consistent manner
  # @param errors [Hash] the hash containing validation errors, generated with record.errors.to_hash(true)
  # @param key [Symbol] the field key to get errors for
  # @return [String, nil] rendered error message or nil if no errors
  def form_error_message(errors, key)
    error = get_formatted_errors(errors, key)
    if error.present?
      content_tag(:div, class: "invalid-feedback") do
        simple_format(error, {}, wrapper_tag: "span")
      end
    end
  end
end
