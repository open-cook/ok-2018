require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Assets should be precompiled for production (so we don't need the gems loaded then)
Bundler.require(*Rails.groups(assets: %w(development test)))

module TheApp
  class Application < Rails::Application
    require_relative 'config'

    # config.active_record.default_timezone = :local
    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    # config.active_record.whitelist_attributes = false
    # config.autoload_paths += %W(#{config.root}/app/controllers/devise_controllers)

    config.autoload_paths += %W(#{ config.root }/app/mailers/concerns/**)
  end
end
