TheApp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true

  # >>>>>> CACHE <<<<<<
  config.action_controller.perform_caching = false

  config.assets.paths << "#{ Rails.root }/public/javascripts"

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # :debug, :info, :warn, :error, :fatal
  config.logger = Logger.new(STDOUT)
  config.logger.level = Logger.const_get(
    ENV['LOG_LEVEL'] ? ENV['LOG_LEVEL'].upcase : 'DEBUG'
  )

  # Disable Rails's static asset server (Apache or nginx will already do this).
  # config.serve_static_assets = false
  config.serve_static_files = true

  # Only use best-standards-support built into browsers.
  config.action_dispatch.best_standards_support = :builtin

  # after_commit exception
  config.active_record.raise_in_transactional_callbacks = true

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL).
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  config.assets.debug = false

  # Enable AssetsPipeline
  config.assets.enabled = true
end
