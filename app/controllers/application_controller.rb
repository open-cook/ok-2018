class ApplicationController < ActionController::Base
  include RoleSystemAddons
  include TheComments::ViewToken
  include UserRoom::StoreDeviseRedirectLocation

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  prepend_view_path "app/views/bootstrap_default"
  prepend_view_path "app/views/#{ AppConfig.theme }"
  prepend_view_path "#{ RailsShop::Engine.root }/app/views/rails_shop"
  prepend_view_path "app/views/ok2"

  before_action :define_user

  after_action ->{
    # https://apps.facebook.com
    if request.referer.to_s.match(/metrika\.yandex/mix)
      response.headers.except! 'X-Frame-Options'
    end

    if request.referer.to_s.match(/webvisor/mix)
      response.headers.except! 'X-Frame-Options'
    end
  }

  private

  def define_user
    @root   = User.root
    @user   = current_user
    user_id = params[:user_id]

    if user_id
      @user = if FriendlyIdPack::Base.int? user_id
        User.find(user_id)
      else
        User.where(login: user_id).first
      end
    end
  end

  def save_audit
    # begin
    #   (@audit || Audit.new.init(self)).save unless ['audits', 'omniauth_callbacks'].include? controller_name
    # rescue; end
  end

  def page_404
    # flash: { error: "Страница не найдена" }
    # redirect_to page_404_path, flash: { error: "Страница не найдена" }
    # flash[:error] = "Страница не найдена"
    # render(template: 'welcome/page_404', status: 404)

    render file: 'public/404.html', status: 404, layout: false
  end

  # only for pages which requested by POST
  def prevent_back_to_page
    response.headers["Pragma"]        = "no-cache"
    response.headers["Expires"]       = "Fri, 01 Jan 1990 00:00:00 GMT"
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
  end
end

# private
# def set_device_type
#   @variant = if browser.mobile?
#     :phone
#   elsif browser.tablet?
#     :tablet
#   end
# end

# def prepend_devices_view_pathes
#   if @variant
#     prepend_view_path "app/views/#{ AppConfig.theme }_#{ @variant }"
#   end
# end

# before_filter :staging_auth
# def staging_auth
#   # unless Rails.env.development?
#   #   authenticate_or_request_with_http_basic do |username, password|
#   #     username == 'test' && password == 'test'
#   #   end
#   # end
# end
