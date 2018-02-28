module UrlHelper
  def tags_links text
    text
  end

  def index_url controller_name
    url_for(controller: controller_name)
  end
end
