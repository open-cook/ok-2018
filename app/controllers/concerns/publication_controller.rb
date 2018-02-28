module PublicationController
  extend ActiveSupport::Concern

  included do
    include MainImageCtrl
    include MainFeedCtrl::Base
    include TheSortableTreeController::ReversedRebuild

    layout 'bootstrap_default', only: %w[ my new edit edit2 slug view_templates manage create update ]

    before_action :set_klass

    before_action :set_pub_and_user, only: (%w[ rebuild show print edit edit2 slug view_templates update destroy ] + MainImageCtrl::ACTIONS)

    before_action :user_require,   except: %w[ index show ]
    before_action :owner_required, except: %w[ index create show my manage new expand_node ]
    before_action :admin_require,  except: %w[ index show ]

    before_action :prepare_all_tags, except: %w[ index new show my manage new ]
  end

  # Public actions

  def index
    @pubs = (User.where(login: user_id).first || @root)
      .send(controller_name)
      .published.recent(:created_at)
      .pagination(params)
  end

  def show
    @hub      = @pub.hub
    @root_hub = @pub.root_hub
    @comments = @pub.comments.for_manage_set

    @hubs = Hub.main_articles_hubs
    @klass.increment_counter(:show_count, @pub.id) if @pub.published?
  end

  def print
    render layout: false, template: 'publications/print'
  end

  def edit2
    render layout: 'advanced_editor', template: 'publications/edit2'
  end

  # def tag
  #   @tag  = params[:tag]
  #   @pubs = @klass.tagged_with(@tag).published.recent(:id).pagination(params)
  #   render 'publications/index'
  # end

  # Restricted actions

  def my
    @pubs = @user.send(controller_name).recent(:id).simple_sort(params).pagination(params)
    render 'publications/manage'
  end

  def manage
    @pubs = if current_user.admin?
      @klass.recent(:id).simple_sort(params).pagination(params)
    else
      @user.send(controller_name).recent(:id).simple_sort(params).pagination(params)
    end

    render 'publications/manage'
  end

  def new
    @pub = @klass.new
    render 'publications/new'
  end

  def create
    @pub = current_user.send(controller_name).new(pub_params)
    @pub.content_processing_for(current_user)

    if @pub.save
      add_pub_in_main_feed(@pub)
      SystemMessage.create_publication(current_user, @pub)
      redirect_to url_for([:edit, @pub]), notice: t("pubs.created")
    else
      render 'publications/new'
    end
  end

  def edit
    render 'publications/edit'
  end

  def slug
    render 'publications/slug'
  end

  def view_templates
    render 'publications/view_templates'
  end

  def update
    @pub.assign_attributes(pub_params)
    @pub.content_processing_for(current_user)
    @pub.update_moderation_info(current_user)

    if @pub.save
      update_main_feed @pub
      redirect_to url_for([:edit, @pub]), notice: t("pubs.updated")
    else
      @pub.update_attachment_fields(:main_image)
      render 'publications/edit'
    end
  end

  def destroy
    @pub.destroy
    destroy_main_feed @pub
    redirect_to cabinet_url
  end

  private

  def render_custom_view opts = {}
    opts = opts.with_indifferent_access

    layout   = opts[:layout]
    template = opts[:template]
    pub      = opts[:publication]

    if pub
      layout   = pub.view_layout   if pub.view_layout.present?
      template = pub.view_template if pub.view_template.present?
    end

    if layout.present? || template.present?
      render({ layout: layout, template: template }.compact)
    end
  end


  def set_klass
    @klass      = controller_name.classify.constantize
    @klass_name = controller_name.singularize.to_sym
  end

  def pub_id
    params[:id]           ||
    params[:post_id]      ||
    params[:blog_id]      ||
    params[:page_id]      ||
    params[:recipe_id]    ||
    params[:interview_id]
  end

  def set_pub_and_user
    @pub = @klass
      .publication_access(current_user)
      .with_users
      .friendly_first(pub_id)

    unless @pub
      @pub = (
        Recipe.where(legacy_url:    pub_id).first  ||
        Post.where(legacy_url:      pub_id).first  ||
        Interview.where(legacy_url: pub_id).first
      )

      return redirect_to(@pub, status: 301) if @pub
    end

    return page_404 unless @pub

    @user = @pub.user
    @owner_check_object = @pub
  end

  def user_id
    params[:user] || params[:user_id]
  end

  def pub_params
    # TODO: user_id for create
    # TODO: user_id for update only for moderator|admin

    params.require(@klass_name).permit(
      :slug,
      :hub_id,
      :main_image,

      :title,
      :raw_intro,
      :raw_content,
      :state,

      :user_id,
      :pub_type,

      :view_layout,
      :view_template,

      :author, :keywords, :description, :copyright,
      :name_list, :word_list, :title_list,
      :comments_switcher,

      :moderation_state,
      :moderator_note,
      :tag_list
    )
  end

  def prepare_all_tags
    @tags = {}
    @tags[:tags] = ActsAsTaggableOn::Tagging
                    .where(context: :tags)
                    .joins(:tag)
                    .pluck('DISTINCT tags.name')
  end
end
