# include TheStorages::AttachedFileHelpers
module TheStorages
  module AttachedFileHelpers
    IMAGE_EXTS = %w[ jpg jpeg pjpeg png x-png gif bmp ]

    def is_image?
      IMAGE_EXTS.include? TheStorages.file_ext(attachment_file_name)
    end

    def file_css_class
      'f_' + TheStorages.file_ext(attachment_file_name)
    end

    def title
      attachment_file_name
    end

    def file_name
      TheStorages.file_name(attachment_file_name)
    end

    def file_ext
      TheStorages.file_ext(attachment_file_name)
    end

    def is_jpg?
      %[ jpg jpeg ].include? file_ext
    end

    def content_type
      attachment_content_type
    end

    def mb_size
      FileSizeHelper.mb_size(attachment_file_size)
    end

    def path style = nil
      attachment.path(style)
    end

    def url style = nil, opts = {}
      url = attachment.url(style, opts)
      return url unless opts[:nocache]
      rnd = (rand*1000000).to_i.to_s
      url =~ /\?/ ? (url + rnd) : (url + '?' + rnd)
    end


  end
end
