window.MultipleFileUpload = do ->
  init: ->
    $("@multiple_file_upload").fileupload
      type:      'POST'
      dataType:  'JSON'
      paramName: 'file'
      dropZone: $('#drug_and_drop_files')

      add: (e, uploader) ->
        uploader.submit()

      done: (e, uploader) ->
        data = uploader.result
        JODY.processor(data)

      fail: (e, uploader) ->
        [ xhr, response, status ] = [ null, uploader.jqXHR, uploader.textStatus ]
        JODY.error_processor(xhr, response, status)

      progressall: (e, data) ->
        progress = parseInt data.loaded / data.total * 100, 10
        progress_bar   = $('@files-uploading-progress-bar')

        if progress < 100
          size = "#{ progress }%"
          progress_bar.show()
          progress_bar.css { width: size }
        else
          progress_bar.hide()
          progress_bar.css { width: '1%' }
