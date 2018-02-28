_root_ = File.expand_path('../../', __FILE__)

require "the_audit/version"

module TheAudit
  def self.is_bot? user_agent
    !!user_agent.to_s.match(/bot|riddler|crawler|spider|slurp|fetcher/mix)
  end

  class Engine < Rails::Engine
    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns/**"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns/**"]
  end
end

# Loading of concerns
require "#{ _root_ }/config/routes.rb"
