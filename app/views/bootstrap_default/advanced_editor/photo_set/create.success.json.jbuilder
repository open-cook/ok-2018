if @new_file.is_image?
  json.file_url image_url @new_file.url(:preview)

  json.flash do |flash|
    flash.alert "Файл '#{ @new_file.attachment_file_name }' загружен"
  end
else
  json.flash do |flash|
    flash.alert "Файл '#{ @new_file.attachment_file_name }' загружен, но неподходит для построение фото галлереи"
  end
end
