require 'user_room/version'

[
  'devise',
  'omniauth-twitter',
  'omniauth-facebook',
  'omniauth-vkontakte',
  'omniauth-google-oauth2',
  'omniauth-odnoklassniki',

  'slim',
  'haml',
  'rails_config',

  'pagination',
  'simple_sort',
  'to_slug_param',

  'mini_magick',
  'paperclip',
  'image_tools',
  'crop_tool',

  'log_js',
  'role_slim_js',
  'protozaur',
  'protozaur_theme',
  'table_holy_grail_layout',
].each { |gem_name| require gem_name }

module UserRoom
  class Engine < Rails::Engine
    config.autoload_paths << "#{ config.root }/app/mailers/concerns/"
  end
end
