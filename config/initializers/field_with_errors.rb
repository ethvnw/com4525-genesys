# frozen_string_literal: true

# Prevent rails from wrapping form elements in a div, which breaks bootstrap validation
ActionView::Base.field_error_proc = proc do |html_tag, _instance|
  html_tag.html_safe
end
