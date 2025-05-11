# frozen_string_literal: true

##
# Helper for pagy
module PagyHelper
  ##
  # Converts pagy's bootstrap navbar into one which uses turbo streams
  def turbo_pager(pagy, **vars)
    html = pagy_bootstrap_nav(pagy, **vars).dup

    # Add data-turbo-stream attribute to all links
    html.gsub!("<a ", '<a data-turbo="true" data-turbo-stream="true" ')
    html.gsub!("&scroll=infinite", "") # Remove infinite scroll query param

    html.html_safe
  end
end
