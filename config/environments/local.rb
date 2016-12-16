Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  # config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # SessionToken = Rails.application.secrets.prs_session_token
  # SharedSecret = Rails.application.secrets.prs_shared_secret
  #
  # timestamp = Time.now.utc.iso8601(3)
  # token_and_time = "#{SessionToken}:#{timestamp}"
  # auth_hash = Base64.strict_encode64 OpenSSL::HMAC.digest('sha256', SharedSecret, token_and_time)
  # auth_token = Base64.strict_encode64 "#{SessionToken}:#{auth_hash}"
  #
  # headers = { "Authorization" => "SIF_HMACSHA256 #{auth_token}",
  #             "Timestamp" => timestamp,
  #             "GeneratorId" => "prs-ui",
  #             "Content-Type" => "application/json",
  #             "Accept" => "application/json",
  #             "ResponseFormat" => "object" }
  #
  # config.action_dispatch.default_headers.merge!(headers)
end
