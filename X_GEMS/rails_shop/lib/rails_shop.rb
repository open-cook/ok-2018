_root_ = File.expand_path('../../', __FILE__)

require "rails_shop/version"

module RailsShop
  class Engine < Rails::Engine
    # config.autoload_paths += %W()
    config.autoload_paths << "#{ config.root }/app/mailers/concerns/"

    initializer "RailsShop: static assets" do |app|
      app.middleware.use(::ActionDispatch::Static, "#{ config.root }/public")
    end
  end
end

# Routing cocerns loading
require "#{ _root_ }/config/routes"
