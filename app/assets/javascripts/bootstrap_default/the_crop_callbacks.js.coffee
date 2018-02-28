@TheCrop ||= {}
@TheCrop.pub_main_image_crop = (data, params) =>
  if data?.ids?
    for id, path of data.ids
      $("##{ id }").attr('src', "#{ path }?nocache=#{ Math.random() }")

  CropTool.finish()
