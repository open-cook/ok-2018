module RoleSystemAddons
  extend ActiveSupport::Concern

  included do
    def not_authenticated
      return redirect_to root_path, alert: 'Недостаточно прав' if current_user
      redirect_to new_user_session_path, alert: t('users.not_authenticated')
    end

    def admin_require
      return not_authenticated unless current_user
      not_authenticated unless current_user.admin?
    end

    def user_require
      not_authenticated unless authenticate_user!
    end

    def owner_required
      not_authenticated unless current_user.owner?(@owner_check_object)
    end
  end
end