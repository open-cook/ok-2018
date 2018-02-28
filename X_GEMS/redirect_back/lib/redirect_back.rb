require "redirect_back/version"

module RedirectBack
  extend ActiveSupport::Concern

  included do
    def redirect_back_or(default_path, opts = {})
      redirect_to :back, opts
      rescue ActionController::RedirectBackError
      redirect_to default_path, opts
    end

    def app_root_path
      respond_to?(:root_path) ? root_path : '/'
    end

    def back_path
      request.referer || app_root_path
    end
  end
end
