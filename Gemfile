# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", ">= 7.0.8", "< 7.1"

# Required to fix Logger bug in Ruby
gem "concurrent-ruby", "1.3.4"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
gem "mutex_m", require: false
gem "drb", require: false
gem "base64"

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

gem "activerecord-session_store"
gem "hamlit"
gem "hamlit-rails"

gem "simple_form"

gem "draper"

gem "shakapacker"

gem "devise"
gem "cancancan"
gem "devise-pwned_password"
gem "devise_invitable"

gem "whenever"
gem "delayed_job"
gem "delayed_job_active_record"
gem "daemons"

gem "sanitize_email"

gem "sentry-ruby"
gem "sentry-rails"

gem "database_cleaner"
gem "annotate"

gem "unsplash"

gem "active_storage_validations"
gem "ruby-vips"

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Live reload when developing [https://github.com/railsjazz/rails_live_reload]
  gem "rails_live_reload"

  gem "letter_opener"
  gem "brakeman"
  gem "bundler-audit"

  gem "capistrano"
  gem "capistrano-rails", require: false
  gem "capistrano-bundler", require: false
  gem "capistrano-rvm", require: false
  gem "capistrano-passenger", require: false
  gem "capistrano-yarn", require: false

  gem "epi_deploy", git: "https://github.com/epigenesys/epi_deploy.git"
  gem "bcrypt_pbkdf", ">= 1.0", "< 2.0"
  gem "ed25519", ">= 1.2", "< 2.0"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "launchy"
  gem "simplecov"
  gem "webmock"
  gem "vcr"
end

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails"
  gem "factory_bot_rails"

  gem "bullet"
end

gem "haml_lint", require: false
gem "rubocop-shopify", require: false
gem "rubocop", "~> 1.68"

# geocoder - used to get country code from request
gem "geocoder", "~> 1.8", ">= 1.8.3"

# countries handle ISO codes [https://github.com/countries/countries]
gem "countries", "~> 7.0"

# turbo - enables SPA-like performance
gem "turbo-rails"
gem "stimulus-rails"

# Allows us to normalise URI to ASCII characters only when making requests with HTTParty
gem "addressable"

# PDF generation
gem "grover"

# Pagination
gem "pagy"

# Blurhash (https://blurha.sh) implementation for ruby
gem "blurhash"
