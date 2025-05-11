# frozen_string_literal: true

require "pagy/extras/bootstrap"
require "pagy/extras/overflow"
Pagy::DEFAULT[:overflow] = :last_page
Pagy::DEFAULT[:limit] = 12 # items per page - multiple of 2 and 3
Pagy::DEFAULT[:size]  = 9  # nav bar links
