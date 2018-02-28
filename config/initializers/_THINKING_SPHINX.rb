if defined? ThinkingSphinx
  class ThinkingSphinx::Configuration
    private

    def settings_file
      framework_root.join 'config', 'ENV', Rails.env.to_s, 'services', 'thinking_sphinx.yml'
    end
  end
end

class ThinkingSphinx::Search
  def pagination params
    page(params[:page]).per(params[:per_page])
  end
end
