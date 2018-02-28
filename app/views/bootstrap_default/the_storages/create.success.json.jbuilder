json.set! :keep_alerts, true

json.set! :flash, {
  notice: "Загружен файл: #{ @new_file.attachment_file_name }"
}

json.set! :html_content, {
  append: {
    selectors: {
      '.attached_files_list' => sortable_tree(@new_file, render_module: AttachedFilesListHelper)
    }
  }
}
