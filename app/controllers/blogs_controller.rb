class BlogsController < ApplicationController
  include PublicationController

  def index
    super
    render_custom_view(template: 'publications/index')
  end

  def show
    super

    render_custom_view(
      publication: @pub,
      layout:   'strict_application',
      template: 'publications/show'
    )
  end
end
