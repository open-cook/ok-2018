# Paperclip Patch
require 'the_storages/paperclip/spoofing_detection_patch'

# TheStorages.config.param_name => value

TheStorages.configure do |config|
  # BSD: /usr/local/bin/
  # MAC: /usr/local/bin/convert
  config.convert_path = '/usr/bin/convert'

  config.watermark_flag = true
  config.watermark_text = 'open-cook.ru    Открытая кухня Анны Нечаевой'
  config.watermarks_path     = "#{ Rails.root.to_s }/public/uploads/watermarks"
  config.watermark_font_path = "#{ Rails.root.to_s }/vendor/fonts/georgia_italic.ttf"

  config.original_larger_side = 1024
  config.base_larger_side     = 800
end
