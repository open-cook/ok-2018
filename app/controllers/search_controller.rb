# frozen_string_literal: true

class SearchController < ApplicationController
  before_action :define_hub_ids

  def autocomplete
    @squery   = params[:term].to_s.strip
    to_search = Riddle::Query.escape @squery

    res = ThinkingSphinx.search(
      to_search,
      star: true,
      classes: SearchService::PUBLICATION_TYPES,
      field_weights: {
        title: 10,
        content: 5
      },
      per_page: 10
    )

    render json: res.map(&:title)
  end

  def search
    search_service = SearchService.call(params[:squery], @hub_ids, params)

    @pubs = search_service.search_result
    @multiple_keyboard_layouts = search_service.multiple_keyboard_layouts

    @search_results_size  = @pubs.size
    @search_results_count = @pubs.count

    render layout: 'ok2/layouts/application', template: 'ok2/search/index'
  end

  def multiple_keyboard_layouts?
    @multiple_keyboard_layouts
  end

  helper_method :multiple_keyboard_layouts?

  private

  def define_hub_ids
    @hub_ids  = []
    @in_blogs = params[:sb]
    @in_posts = params[:sp]

    if @in_blogs && blog_hub = Hub.with_slug(:blogs)
      @hub_ids << blog_hub.self_and_descendants.select(:id).map(&:id).uniq
    end

    if @in_posts && post_hub = Hub.with_slug(:posts)
      @hub_ids << post_hub.self_and_descendants.select(:id).map(&:id).uniq
    end
  end
end
