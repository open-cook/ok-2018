# TheAudit::Routes.mixin(self)
module TheAudit
  class Routes
    def self.mixin mapper
      mapper.resources :audits, except: %w[ new create ]
    end
  end
end

