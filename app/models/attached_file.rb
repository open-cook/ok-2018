class AttachedFile < ActiveRecord::Base
  include TheStorages::AttachedFile
  include Notifications::LocalizedErrors
  include TheStorages::Watermarks

  def create_version_base
    src  = path
    base = path :base

    create_path_for_file base

    manipulate({ src: src, dest: base, larger_side: 580 }) do |image, opts|; biggest_side_not_bigger_than(image, opts[:larger_side]); end

    FileUtils.chmod 0644, base

    build_watermarks
    watermark_on_base

    optimize_base
  end

  def watermark_on_base
    base  = path :base
    image = MiniMagick::Image.open base

    # top    = north
    # bottom = south
    # right  = east
    # left   = west

    watermark = watermark_path
    position  = :south
    x_shift   = "+0"
    y_shift   = "+10"

    if portrait?(image)
      watermark =  watermark_path(:portrait)
      position  = :east
      x_shift   = "+10"
      y_shift   = "+0"
    end

    stick   = "-gravity #{ position }"
    shift   = "-geometry #{ x_shift }#{ y_shift }"
    opacity = '' # "-dissolve 80%"

    Cocaine::CommandLine.new("composite", " #{ stick } #{ shift } #{ opacity } #{ watermark } #{ base } #{ base }").run
  end

  def optimize_base
    return unless is_jpg?
    # pngquant: false, svgo: false, pngcrush: false, advpng: false
    image_optim = ImageOptim.new(advpng: false)
    image_optim.optimize_image! path(:base)
  end
end
