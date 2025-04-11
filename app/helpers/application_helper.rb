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
  # @return [String] a Bootstrap HTML element containing the link
  def navbar_link_to(name, icon, path)
    content_tag(:li, class: "nav-item") do
      link_to(path, class: "#{"active" if current_page?(path)} nav-link") do
        concat(content_tag(:i, nil, class: "#{current_page?(path) ? "#{icon}-fill" : icon} bi"))
        concat(content_tag(:span, name))
      end
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
