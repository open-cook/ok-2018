# frozen_string_literal: true

class SearchController < ApplicationController
  before_action :define_hub_ids

  def pub_types
    [Recipe, Post, Blog, Page, Interview]
  end

  def autocomplete
    @squery = params[:term].to_s.strip
    riddle_query = Riddle::Query.escape @squery

    search_result = ThinkingSphinx.search(
      riddle_query,
      star: true,
      classes: pub_types,
      field_weights: {
        title: 10,
        content: 5
      },
      per_page: 10
    )

    attributes = search_result.map do |resource|
      {
        label: resource.title,
        image: resource.main_image(:base)
      }
    end

    render json: attributes
  end

  def search
    @squery   = params[:squery].to_s.strip
    to_search = Riddle::Query.escape @squery

    @pubs = if @hub_ids.blank?
              ThinkingSphinx.search(to_search, star: true, classes: pub_types, sql: { include: :hub }).pagination(params)
            else
              ThinkingSphinx.search(to_search, star: true, classes: pub_types, sql: { include: :hub }, with: { hub_id: @hub_ids }).pagination(params)
    end

    @search_results_size  = @pubs.size
    @search_results_count = @pubs.count

    render layout: 'ok2/layouts/application', template: 'ok2/search/index'
  end

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
