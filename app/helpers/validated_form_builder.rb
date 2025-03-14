# frozen_string_literal: true

include ActionView::Helpers::TextHelper

class ValidatedFormBuilder < SimpleForm::FormBuilder
  def validated_input(attribute_name, error, element_options = {})
    input_options = element_options.dup

    input_options[:class] =
      "form-control#{" is-invalid" if error}#{" is-valid" if options[:is_form_submitted] && !error}"

    column = find_attribute_column(attribute_name)
    default_input_type(attribute_name, column, element_options)

    @template.content_tag(:div, class: element_options[:class]) do
      # Use label from options if one is defined, with attribute name as default
      label(element_options.fetch(:label, attribute_name), class: "form-label") +
        input_field(attribute_name, input_options) +
        @template.content_tag(:div, simple_format(error), class: "invalid-feedback") +
        @template.content_tag(:div, "Looks Good!", class: "valid-feedback")
    end
  end

  def validated_select(attribute_name, choices, error, element_options = {})
    input_options = element_options.dup

    input_options[:class] =
      "form-select form-control#{" is-invalid" if error}#{" is-valid" if options[:is_form_submitted] && !error}"

    column = find_attribute_column(attribute_name)
    default_input_type(attribute_name, column, element_options)

    @template.content_tag(:div, class: element_options[:class]) do
      # Use label from options if one is defined, with attribute name as default
      label(element_options.fetch(:label, attribute_name), class: "form-label") +
        select(attribute_name, choices, input_options, input_options) +
        @template.content_tag(:div, simple_format(error), class: "invalid-feedback") +
        @template.content_tag(:div, "Looks Good!", class: "valid-feedback")
    end
  end
end
