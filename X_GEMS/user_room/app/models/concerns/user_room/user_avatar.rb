module UserRoom
  module UserAvatar

    extend ActiveSupport::Concern

    included do
      include ImageTools

      before_validation :generate_avatar_name

      # after_commit :avatar_original_resize
      after_commit :avatar_build_variants

      has_attached_file :avatar,
        default_url: "/user_room/avatar/:style/missing.png",
        path:        ":rails_root/public/uploads/:class/:attachment/:id/:style/:filename",
        url:         "/uploads/:class/:attachment/:id/:style/:filename"

      validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

    end # included

    def generate_avatar_name
      if avatar.present? && changes[:avatar_updated_at]
        file_name = [SecureRandom.hex[0..10], 'png'].join '.'
        avatar.instance_write :file_name, file_name
      end
    end


    def avatar_crop_1x1 params
      crop_params = params[:crop].symbolize_keys

      src      = avatar.path
      v500x500 = avatar.path :v500x500
      v100x100 = avatar.path :v100x100

      manipulate({ src: src, dest: v500x500 }.merge(crop_params)) do |image, opts|
        scale = image[:width].to_f / opts[:img_w].to_f
        image = crop image, opts[:x], opts[:y], opts[:w], opts[:h], { scale: scale, repage: false }
        image = strict_resize image, 500, 500
        image
      end

      manipulate({ src: v500x500, dest: v100x100 }) do |image, opts|
        image = strict_resize image, 100, 100
        image
      end

      avatar.url(:v500x500, timestamp: false)
    end

    def avatar_rotate_left
      return false unless avatar?

      image_variants = all_image_variants.push(avatar.path)

      image_variants.each do |image_path|
        manipulate({ src: image_path, dest: image_path }) do |image, opts|
          rotate_left image
        end
      end
    end

    def avatar_rotate_right
      return false unless avatar?

      image_variants = all_image_variants.push(avatar.path)

      image_variants.each do |image_path|
        manipulate({ src: image_path, dest: image_path }) do |image, opts|
          rotate_right image
        end
      end
    end

    def avatar_build_variants
      if avatar.present? && previous_changes[:avatar_updated_at]
        src  = avatar.path

        ###########################
        # VARIANTS
        ###########################

        v500x500 = avatar.path(:v500x500)
        v100x100 = avatar.path(:v100x100)
        v50x50   = avatar.path(:v50x50)

        ###########################
        # ~ VARIANTS
        ###########################

        # src prepare
        manipulate({ src: src, dest: src, larger_side: 800 }) do |image, opts|
          image = auto_orient image
          image = optimize    image
          image = strip       image
          image = biggest_side_not_bigger_than(image, opts[:larger_side])
        end

        # 1x1
        manipulate({ src: src, dest: v500x500, larger_side: 500 }) do |image, opts|
          image = to_square image, 500, { repage: true }
          image
        end

        manipulate({ src: v500x500, dest: v100x100 }) do |image, opts|
          image = to_square image, 100
          image
        end

        manipulate({ src: v100x100, dest: v50x50 }) do |image, opts|
          image = to_square image, 50
          image
        end
      end
    end

    def avatar_destroy!
      destroy_file( all_image_variants )
      avatar.destroy
      save!
    end

    def all_image_variants
      [
        avatar.path(:v500x500),
        avatar.path(:v100x100),
        avatar.path(:v50x50)
      ]
    end

  end # UserAvatar
end # UserRoom
