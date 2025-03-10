# frozen_string_literal: true

class ValidatedFormBuilder < SimpleForm::FormBuilder
  def validated_text_input(attribute_name, error, options = {})
    input_options = options.dup

    input_options[:class] = "form-control#{
      if error
        " is-invalid"
      else
        options[:has_been_validated] ? " is-valid" : ""
      end
    }"

    column = find_attribute_column(attribute_name)
    default_input_type(attribute_name, column, options)

    @template.content_tag(:div, class: options[:class]) do
      label(attribute_name, class: "form-label") +
        input_field(attribute_name, input_options) +
        @template.content_tag(:div, error, class: "invalid-feedback") +
        @template.content_tag(:div, "Looks Good!", class: "valid-feedback")
    end
  end
end
