# frozen_string_literal: true

include ActionView::Helpers::TextHelper

##
# Custom form builder that makes use of bootstrap's validation classes, and structures HTML in a more logical way than
# the default SimpleForm::FormBuilder
#
# @example
#   = simple_form_for(@user, builder: ValidatedFormBuilder, errors: @user.errors.to_hash(true)) do |f|
#     = f.validated_input(:email)
#     = f.validated_select(:role, User.roles.keys)
#     = f.validated_datetime(:birthday)
class ValidatedFormBuilder < SimpleForm::FormBuilder
  ##
  # Creates a validated text input field with error handling
  # @param attribute_name [Symbol] the name of the attribute to create an input for
  # @param element_options [Hash] options for the input element
  # @option element_options [Symbol] :error_key the key to use for error messages (defaults to attribute_name)
  # @option element_options [String] :hint optional hint text to display below the input
  # @option element_options [String] :label custom label text (defaults to attribute_name.humanize)
  # @option element_options [String] :class additional CSS classes
  # @option element_options [String] :input_class CSS classes for the input element
  # @return [String] HTML for the input field with validation
  def validated_input(attribute_name, element_options = {})
    error = get_formatted_errors(element_options[:error_key] || attribute_name)
    element_options.delete(:error_key)

    input_options = get_input_options(attribute_name, error, element_options)

    build_input(
      attribute_name,
      error,
      input_field(attribute_name, input_options),
      get_hint_element(attribute_name, input_options),
      element_options,
    )
  end

  ##
  # Creates a validated select field with error handling
  # @param attribute_name [Symbol] the name of the attribute to create a select for
  # @param choices [Array] array of choices for the select field
  # @param element_options [Hash] options for the select element
  # @option element_options [Symbol] :error_key the key to use for error messages (defaults to attribute_name)
  # @option element_options [String] :hint optional hint text to display below the input
  # @option element_options [String] :label custom label text (defaults to attribute_name.humanize)
  # @option element_options [String] :class additional CSS classes
  # @option element_options [String] :input_class CSS classes for the input element
  # @return [String] HTML for the select field with validation
  def validated_select(attribute_name, choices, element_options = {})
    error = get_formatted_errors(element_options[:error_key] || attribute_name)
    element_options.delete(:error_key)

    input_options = get_input_options(attribute_name, error, element_options, "form-select")

    build_input(
      attribute_name,
      error,
      select(attribute_name, choices, input_options, input_options),
      get_hint_element(attribute_name, input_options),
      element_options,
    )
  end

  ##
  # Creates a validated datetime input field with error handling
  # @param attribute_name [Symbol] the name of the attribute to create a datetime input for
  # @param element_options [Hash] options for the datetime input element
  # @option element_options [Symbol] :error_key the key to use for error messages (defaults to attribute_name)
  # @option element_options [String] :hint optional hint text to display below the input
  # @option element_options [String] :label custom label text (defaults to attribute_name.humanize)
  # @option element_options [String] :class additional CSS classes
  # @option element_options [String] :input_class CSS classes for the input element
  # @return [String] HTML for the datetime input field with validation
  def validated_datetime(attribute_name, element_options = {})
    error = get_formatted_errors(element_options[:error_key] || attribute_name)
    element_options.delete(:error_key)

    input_options = get_input_options(attribute_name, error, element_options)

    build_input(
      attribute_name,
      error,
      datetime_local_field(attribute_name, input_options),
      get_hint_element(attribute_name, input_options),
      element_options,
    )
  end

  private

  ##
  # Retrieves and formats error messages for a specific field
  # @param key [Symbol] the key to get errors for
  # @return [String, nil] formatted error messages or nil if no errors
  def get_formatted_errors(key)
    errors = options[:errors] || {}
    errors_for_key = errors[key]

    if errors_for_key.present?
      errors_for_key.join("\n")
    end
  end

  ##
  # Builds input options with validation classes
  # @param attribute_name [Symbol] the name of the attribute
  # @param error [String, nil] error message - if any
  # @param element_options [Hash] original element options
  # @param additional_classes [String] additional CSS classes to add
  # @return [Hash] processed input options
  def get_input_options(attribute_name, error, element_options, additional_classes = "")
    input_options = element_options.dup

    input_options[:class] = "#{input_options[:input_class] || "form-control"} #{additional_classes}".strip
    input_options.delete(:input_class)

    if error.present?
      input_options[:class] += " is-invalid"
    elsif should_show_valid_feedback?(attribute_name)
      # Don't show is-valid for password fields, as their values are not kept between loads
      input_options[:class] += " is-valid"
    end

    input_options
  end

  ##
  # Creates a hint element if hint text is provided
  # @param attribute_name [Symbol] the name of the attribute
  # @param input_options [Hash] input options containing hint text
  # @return [String, nil] HTML for the hint element or nil if no hint
  def get_hint_element(attribute_name, input_options)
    hint_text = input_options[:hint]
    input_options.delete(:hint)

    if hint_text.present?
      input_options["aria-describedby"] = attribute_name.to_s + "_hint"

      @template.content_tag(
        :small,
        hint_text,
        id: "#{attribute_name}_hint",
        class: "form-text form-muted mt-0 mb-1",
      )
    end
  end

  ##
  # Builds the complete input element with label, hint, and feedback
  # @param attribute_name [Symbol] the name of the attribute
  # @param error [String, nil] error message if any
  # @param input_element [String] the input HTML
  # @param hint_element [String, nil] hint HTML if any
  # @param element_options [Hash] element options
  # @return [String] complete HTML for the form field
  def build_input(attribute_name, error, input_element, hint_element, element_options)
    # Parse input ID with Nokogiri to add as "for" attribute on label
    input_id = Nokogiri::HTML5.fragment(input_element).children[0]["id"]
    label_text = element_options.fetch(:label, attribute_name)

    # Unless label option is explicitly set to nil, set label text
    label_element = label_text.nil? ? nil : label(label_text, class: "mb-1", for: input_id)

    @template.content_tag(:div, class: "#{element_options[:class]} d-flex flex-column mb-3") do
      child_elements = ActiveSupport::SafeBuffer.new

      child_elements += label_element
      child_elements += hint_element

      child_elements += input_element

      # Create & add feedback tags
      child_elements += @template.content_tag(
        :div,
        simple_format(error, {}, wrapper_tag: "span"),
        class: "invalid-feedback",
      )
      child_elements += @template.content_tag(:div, "Looks Good!", class: "valid-feedback")

      child_elements
    end
  end

  ##
  # Determines if valid feedback should be shown for an attribute
  # Will show if there are errors, and the attribute is not a password
  # @param attribute_name [Symbol] the name of the attribute
  # @return [Boolean] whether to show valid feedback
  def should_show_valid_feedback?(attribute_name)
    options[:errors].present? && !attribute_name.to_s.include?("password")
  end
end
