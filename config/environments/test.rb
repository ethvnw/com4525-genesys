# frozen_string_literal: true

require "active_support/core_ext/integer/time"

# Require custom middleware
require_relative "../../lib/middleware/test_ip_mock.rb"

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  config.after_initialize do
    Bullet.enable        = true
    Bullet.bullet_logger = true
    Bullet.raise         = true # raise an error if n+1 query occurs

    # Don't warn about unused eager loading
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

  # Turn false under Spring and add config.action_view.cache_template_loading = true.
  config.cache_classes = true

  # Eager loading loads your whole application. When running a single test locally,
  # this probably isn't necessary. It's a good idea to do in a continuous integration
  # system, or in some way before deploying your code.
  config.eager_load = ENV["CI"].present?

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}",
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # For testing the uploading of images
  config.active_storage_service = :test

  ##########################################################################
  # All settings above this line are generated automatically by running    #
  # `rails new ...`                                                        #
  # Intentionally kept format to make it more obvious / easier to upgrade. #
  ##########################################################################

  # Set up email configuration
  config.action_mailer.default_url_options = { host: "localhost:3000" }

  # Make sure we know about it if params haven't been permitted
  config.action_controller.action_on_unpermitted_parameters = :raise
  config.middleware.use(TestIpMock)
end
