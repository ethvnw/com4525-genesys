# frozen_string_literal: true

Grover.configure do |config|
  config.options = {
    format: "A4",
    margin: { top: "1.5cm", bottom: "1.5cm", left: "1cm", right: "1cm" },
    print_background: true,
    display_header_footer: true,
    header_template: "<div class='text left'><span class='title'></span></div>",
    footer_template: "<div class='text left'><span class='pageNumber'></span>/<span class='totalPages'></span></div>",
  }
end
