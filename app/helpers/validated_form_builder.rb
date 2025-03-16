# frozen_string_literal: true

include ActionView::Helpers::TextHelper

##
# Custom form builder that makes use of bootstrap's validation classes, and structures HTML in a more logical way than
# the default SimpleForm::FormBuilder
class ValidatedFormBuilder < SimpleForm::FormBuilder
  def validated_input(attribute_name, error, element_options = {})
    input_options = get_input_options(attribute_name, error, element_options)
    puts input_field(attribute_name, input_options)
    build_input(
      attribute_name,
      error,
      input_field(attribute_name, input_options),
      get_hint_element(attribute_name, input_options),
      element_options,
    )
  end

  def validated_select(attribute_name, choices, error, element_options = {})
    input_options = get_input_options(attribute_name, error, element_options, "form-select")

    build_input(
      attribute_name,
      error,
      select(attribute_name, choices, input_options, input_options),
      get_hint_element(attribute_name, input_options),
      element_options,
    )
  end

  def validated_datetime(attribute_name, error, element_options = {})
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

  def get_input_options(attribute_name, error, element_options, additional_classes = "")
    input_options = element_options.dup

    input_options[:class] = "#{input_options[:input_class] || "form-control"} #{additional_classes}".strip
    input_options.delete(:input_class)

    if error
      input_options[:class] += " is-invalid"
    elsif options[:is_form_submitted] && !attribute_name.to_s.include?("password")
      # Don't show is-valid for password fields, as their values are not kept between loads
      input_options[:class] += " is-valid"
    end

    input_options
  end

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

  def build_input(attribute_name, error, input_element, hint_element, element_options)
    # Parse input ID with Nokogiri to add as "for" attribute on label
    input_id = Nokogiri::HTML5.fragment(input_element).children[0]["id"]

    @template.content_tag(:div, class: "#{element_options[:class]} d-flex flex-column mb-3") do
      # Use label from options if one is defined, with attribute name as default
      child_elements = label(element_options.fetch(:label, attribute_name), class: "mb-1", for: input_id)

      child_elements += hint_element
      child_elements += input_element

      child_elements += @template.content_tag(
        :div,
        simple_format(error, {}, wrapper_tag: "span"),
        class: "invalid-feedback",
      )
      child_elements += @template.content_tag(:div, "Looks Good!", class: "valid-feedback")

      child_elements
    end
  end
end
