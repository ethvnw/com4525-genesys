# frozen_string_literal: true

require_relative "../../lib/active_storage_extensions/blurhash/analyser"

# Use custom analyser for active storage
Rails.application.config.active_storage.analyzers.prepend(ActiveStorageExtensions::Blurhash::Analyser)
