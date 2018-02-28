@MainImage = do ->
  init: ->
    @inited ||= do =>
      doc = $ document

      doc.on 'click', '@main-image-manage-switcher', ->
        if $('@main-image-manage-intro:visible').length
          $('@main-image-manage-intro').slideUp ->
            $('@main-image-manage').slideDown()
        else
          $('@main-image-manage').slideUp ->
            $('@main-image-manage-intro').slideDown()

  crop_tool_callback: (data, btn_params) ->
    if data?.ids?
      for id, src of data.ids
        $(id).attr 'src', src

    CropTool.finish()
