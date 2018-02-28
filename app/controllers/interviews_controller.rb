class InterviewsController < ApplicationController
  include PublicationController

  def index
    super
    render template: 'publications/index'
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
