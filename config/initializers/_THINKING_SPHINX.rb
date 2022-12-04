if defined? ThinkingSphinx
  # Version 3
  class ThinkingSphinx::Configuration
    private

    def settings_file
      framework_root.join 'config', 'ENV', Rails.env.to_s, 'services', 'thinking_sphinx.yml'
    end
  end

  # Version 5
  class ThinkingSphinx::Settings
    private

    def file
      @file ||= Pathname.new(framework.root).join 'config', 'ENV', Rails.env.to_s, 'services', 'thinking_sphinx.yml'
    end
  end
end

class ThinkingSphinx::Search
  def pagination params
    page(params[:page]).per(params[:per_page])
  end
end
