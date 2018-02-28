class WelcomeController < ApplicationController
  def bug;        0/0; end
  def detect_403; 0/0; end
  def detect_404; 0/0; end
  def detect_422; 0/0; end
  def detect_500; 0/0; end

  def index
    @blogs_hubs   = Hub.published_tree(:blogs)
    @posts_hubs   = Hub.published_tree(:posts)
    @recipes_hubs = Hub.published_tree(:recipes)

    @pubs = MainFeed.recent(:created_at).published.moderated.includes(:publication).pagination(params)
    render template: 'ok2/welcome/index', layout: 'ok2/layouts/application'
  end

  # RSS FEEDS
  def rss
    @posts = Recipe.published.recent(:created_at).limit(10)
    render template: '_rss/recipes'
  end

  def sitemap
    @posts  = Product.published.in_stock.max2min(:created_at)
    @posts |= Recipe.published.recent(:created_at)
    @posts |= Post.published.recent(:created_at)
    @posts |= Interview.published.recent(:created_at)
    @posts |= Blog.published.recent(:created_at)

    render template: '_xml/sitemap'
  end

  # Legacy urls
  def legacy_search
    if q = params[:q]
      return redirect_to qsearch_path(q), status: :moved_permanently
    end

    redirect_to root_path, status: 422
  end

  def legacy_menu
    if hub = Hub.where(legacy_url: params[:id]).first
      return redirect_to hub_url(hub), status: :moved_permanently
    end

    page_404
  end

  def recepty_2016
    @tag = "новогодние рецепты"

    tag_name = ActsAsTaggableOn::Tag.send(:comparable_name, @tag)
    tag = ActsAsTaggableOn::Tag.where(name: tag_name).first

    @taggings = if tag
      tag.taggings.includes(:published_pub)
      .recent(:created_at).pagination(params)
    else
      ActsAsTaggableOn::Tag.none
    end
  end

  # def legacy_articles
  #   if tag = params[:tag]
  #     return redirect_to tag_path(tag), status: :moved_permanently
  #   end
  #   redirect_to posts_path, status: :moved_permanently
  # end

  # def legacy_post
  #   c_slug = params[:c_slug]
  #   s_slug = params[:s_slug]
  #   id     = params[:id]
  #   if post = Post.where(legacy_url: "#{ c_slug }/#{ s_slug }/#{ id }").first
  #     return redirect_to post_url(post), status: :moved_permanently
  #   end
  #   redirect_to root_path, flash: { error: "Страница не найдена" }
  # end

  # def legacy_blog
  #   id = params[:id]
  #   if blog = Hub.find_by(slug: :blogs).blogs.where(legacy_url: id).published.first
  #     return redirect_to post_url(blog), status: :moved_permanently
  #   end
  #   redirect_to root_path, flash: { error: "Страница не найдена" }
  # end
end
