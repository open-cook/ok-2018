require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == 'admin' && password == 'qwerty'
end

TheApp::Application.routes.draw do
  mount Sidekiq::Web => '/async/tasks'

  # SPECIAL PROJECTS
  get 'tag/новогодние рецепты',  to: redirect('/novogodnie-recepty-2016', status: 301)
  get 'novogodnie-recepty-2016' => 'welcome#recepty_2016'

  ##########################
  # USER ROOM
  ##########################

  # Login system
  devise_for :users, path: '',
    :path_names => {
      sign_in:  'login',
      sign_up:  'signup',
      sign_out: 'logout'
    },
    :controllers => {
      :omniauth_callbacks => "devise_controllers/omniauth_callbacks",
      :confirmations      => "devise_controllers/confirmations",
      :registrations      => "devise_controllers/registrations",
      :sessions           => "devise_controllers/sessions",
      :passwords          => "devise_controllers/passwords"
    }

  devise_scope :user do
    get  'account_should_be_activate' => 'devise_controllers/registrations#account_should_be_activate'

    post 'create_email_registration_request'        => 'devise_controllers/registrations#create_email_registration_request',   as: :create_email_registration_request
    get  'activate_email_registration_request/:uid' => 'devise_controllers/registrations#activate_email_registration_request', as: :activate_email_registration_request

    post 'create_onetime_login_link'        => 'devise_controllers/sessions#create_onetime_login_link',   as: :create_onetime_login_link
    get  'activate_onetime_login_link/:uid' => 'devise_controllers/sessions#activate_onetime_login_link', as: :activate_onetime_login_link

    delete 'omniauth/provider/:provider' => 'devise_controllers/omniauth_callbacks#delete_provider', as: :delete_provider
  end

  # Personal
  get  "cabinet"       => "users#cabinet",       as: :cabinet
  post "autologin/:id" => 'users#autologin',     as: :autologin
  get  "admin_cabinet" => "users#admin_cabinet", as: :admin_cabinet

  ##########################
  # ~ USER ROOM
  ##########################

  ##########################
  # SHOP
  ##########################

  get 'stats-2015', to: redirect('https://open-cook.ru/pages/publichnyj-otchet-za-2015-god', status: 301)

  get 'shop/manage' => 'shop#manage',    as: :shop_manage
  get '/shop-dev',  to: redirect('/shop', status: 301)
  get '/shop'       => 'products#index', as: :shop

  # Yandex Kassa test routes
  #
  # match 'payments/test/yk/check-url' => 'payments#yk_check_test',   via: %w[ get post ]
  # match 'payments/test/yk/aviso-url' => 'payments#yk_aviso_test',   via: %w[ get post ]
  # match 'payments/test/yk/success'   => 'payments#yk_success_test', via: %w[ get post ]
  # match 'payments/test/yk/failure'   => 'payments#yk_failure_test', via: %w[ get post ]

  # Yandex Kassa routes
  match 'payments/yk/check-url' => 'payments#yk_check',   via: %w[ get post ]
  match 'payments/yk/aviso-url' => 'payments#yk_aviso',   via: %w[ get post ]
  match 'payments/yk/success'   => 'payments#yk_success', via: %w[ get post ]
  match 'payments/yk/failure'   => 'payments#yk_failure', via: %w[ get post ]

  resources :orders do
    member do
      get :payment_system
      get :login_before
      get :attach_current_user_to

      patch :recalc_price
      patch :completion
      get   :payment
    end

    collection do
      get :my
      get :search
      get :manage
    end
  end

  resources :carts do
    member do
      delete :reset
      patch :set_delivery_type

      patch  :amount_decrement
      patch  :amount_increment
    end

    collection do
      get :manage
    end
  end

  # ADD/REMOVE PRODUCTS
  post   "add_to_cart/:product_id"      => "carts#add_product",    as: :add_to_cart
  delete "remove_from_cart/:product_id" => "carts#remove_product", as: :remove_from_cart

  resources :delivery_types do
    collection do
      get :manage
    end

    member do
      patch  :main_image_crop_16x9
      patch  :main_image_crop_4x3
      patch  :main_image_crop_1x1

      patch  :main_image_rotate_left
      patch  :main_image_rotate_right

      delete :main_image_delete
    end
  end

  resources :product_categories do
    collection do
      get :manage
    end

    member do
      patch  :main_image_crop_16x9
      patch  :main_image_crop_4x3
      patch  :main_image_crop_1x1

      patch  :main_image_rotate_left
      patch  :main_image_rotate_right

      delete :main_image_delete
    end
  end

  resources :products do
    member do
      patch :realtion_category
    end

    collection do
      get :manage
    end

    member do
      patch  :main_image_crop_16x9
      patch  :main_image_crop_4x3
      patch  :main_image_crop_1x1

      patch  :main_image_rotate_left
      patch  :main_image_rotate_right

      delete :main_image_delete
    end
  end

  ##########################
  # ~ SHOP
  ##########################

  # Base
  root to: 'welcome#index'

  # redirects
  get '/resto', to: redirect('/hubs/resto', status: 301)

  RailsShop::Routes.mixin(self)

  resources :attached_files do
    post :photo_set_uploader, on: :collection
  end

  get '/bug'        => 'welcome#bug'
  get '/detect_403' => 'welcome#detect_403'
  get '/detect_404' => 'welcome#detect_404'
  get '/detect_422' => 'welcome#detect_422'
  get '/detect_500' => 'welcome#detect_500'

  get '/page_404'  => 'welcome#page_404', as: :page_404
  get '/menus/:id' => 'welcome#legacy_menu'

  # # XML feeds
  get '/recipes.rss'       => 'welcome#rss',     defaults: { format: :rss }
  get '/sitemap.xml'       => 'welcome#sitemap', defaults: { format: :xml }

  # Search
  post "autocomplete" => "search#autocomplete", as: :autocomplete
  get  "search/:squery" => "search#search",     as: :search

  # Subscribers
  post "subscribers/add" => "subscribers#add", as: :add_subscriber

  resources :meta_data

  # TheAudit::Routes.mixin(self)

  # TheComments
  concern   :user_comments,  TheComments::UserRoutes.new
  concern   :admin_comments, TheComments::AdminRoutes.new
  resources :comments, concerns:  [:user_comments, :admin_comments]

  concern :sortable_tree do
    collection do
      get  :manage
      post :rebuild
    end
  end

  # Direct routes
  %w{ hubs pages posts blogs recipes interviews hots }.each do |name|
    resources name, concerns: :sortable_tree do
      get :print
      get :slug
      get :view_templates
      get :edit2

      member do
        patch  :main_image_crop_base
        patch  :main_image_crop_preview
        patch  :main_image_rotate
        delete :main_image_delete
      end
    end
  end

  resources :hubs do
    post :expand_node, on: :collection
  end

  # Users
  resources :users, only: %w[ index show edit update ] do
    patch  :change_email
    patch  :change_password

    # patch  :avatar_crop
    # delete :avatar_delete

    member do
      patch  :avatar_crop_1x1

      patch  :avatar_rotate_left
      patch  :avatar_rotate_right

      delete :avatar_delete
    end

    %w[ hubs pages posts blogs recipes interviews hots ].each do |name|
      resources name, concerns: :sortable_tree do
        get :my, on: :collection
      end

      resources name, concerns: :sortable_tree
    end
  end

  # tags
  get "tag/:tag" => "tags#show", as: :tag

  # Mailer
  # get '/rails/mailers' => "rails/mailers#index"
  # get '/rails/mailers/*path' => "rails/mailers#preview"

  scope 'api' do
    get 'recipes' => 'recipes#index'
  end
end
