# frozen_string_literal: true

Rails.application.config.x.session_cookie_name = (
  Rails.env.production? ? "roamio_session_id" : "roamio_#{Rails.env}_session_id"
)

Rails.application.config.action_dispatch.cookies_same_site_protection = :lax

Rails.application.config.session_store(
  :active_record_store,
  key: Rails.application.config.x.session_cookie_name,
  secure: !Rails.env.development? && !Rails.env.test?,
  httponly: true,
)
