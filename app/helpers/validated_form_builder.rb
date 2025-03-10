# frozen_string_literal: true

include ActionView::Helpers::TextHelper

class ValidatedFormBuilder < SimpleForm::FormBuilder
  def validated_input(attribute_name, error, options = {})
    input_options = options.dup

    input_options[:class] = "form-control#{" is-invalid" if error}"

    column = find_attribute_column(attribute_name)
    default_input_type(attribute_name, column, options)

    @template.content_tag(:div, class: options[:class]) do
      label(attribute_name, class: "form-label") +
        input_field(attribute_name, input_options) +
        @template.content_tag(:div, simple_format(error), class: "invalid-feedback") +
        @template.content_tag(:div, "Looks Good!", class: "valid-feedback")
    end
  end
end
