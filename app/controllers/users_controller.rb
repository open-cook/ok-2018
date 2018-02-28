class UsersController < ApplicationController
  include UserRoom::UsersController

  before_action :user_require,   except: %w[ index show new ]
  before_action :owner_required, except: %w[ index show new cabinet admin_cabinet autologin ]

  before_action :admin_require,
    except: %w[
      index show
      cabinet edit update
      avatar_crop avatar_delete
      change_password change_email
    ] + ::UserRoom::UserAvatarActions::ACTIONS_NAMES

  def cabinet
    @orders = @user.orders.max2min(:created_at).for_user.limit(10)
  end

end
