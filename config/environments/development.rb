# frozen_string_literal: true

require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.after_initialize do
    Bullet.enable        = true
    Bullet.alert         = true
    Bullet.bullet_logger = true
    Bullet.console       = true
    Bullet.rails_logger  = true
    Bullet.add_footer    = true

    # Don't warn about unused loading of avatar
    # Eager load needed for most requests, but bullet warns when it is being used in a turbo stream request.
    # However, it will be needed for the HTML equivalent request of any turbo stream ones, so safer to just
    # eager-load anyway.
    Bullet.add_safelist(type: :unused_eager_loading, class_name: "User", association: :avatar_attachment)
    Bullet.add_safelist(type: :unused_eager_loading, class_name: "ActiveStorage::Attachment", association: :blob)
    Bullet.add_safelist(type: :unused_eager_loading, class_name: "Plan", association: :documents_attachments)
    Bullet.add_safelist(type: :unused_eager_loading, class_name: "Trip", association: :trip_memberships)
    Bullet.add_safelist(type: :unused_eager_loading, class_name: "TripMembership", association: :user)
  end

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}",
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true

  ##########################################################################
  # All settings above this line are generated automatically by running    #
  # `rails new ...`                                                        #
  # Intentionally kept format to make it more obvious / easier to upgrade. #
  ##########################################################################

  # Preview email in the browser instead of sending it
  config.action_mailer.default_url_options = { host: "localhost:3000" }
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true

  # Make sure we know about it if params haven't been permitted
  config.action_controller.action_on_unpermitted_parameters = :raise

  # Test error pages in development
  # config.consider_all_requests_local = false
end
