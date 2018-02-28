module MainImageCtrl
  ACTIONS = %w[
    main_image_crop_base
    main_image_crop_preview
    main_image_rotate
    main_image_delete
  ]

  def main_image_crop_base
    path = @pub.main_image_crop_base(params)
    render json: { ids: { main_image_base_pic: path } }
  end

  def main_image_crop_preview
    path = @pub.main_image_crop_preview(params)
    render json: { ids: { main_image_preview_pic: path } }
  end

  def main_image_rotate
    @pub.main_image_rotate
    redirect_to :back
  end

  def main_image_delete
    @pub.main_image_destroy!
    redirect_to :back
  end
end
