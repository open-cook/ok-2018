module BasePublication
  extend ActiveSupport::Concern

  included do
    acts_as_taggable
    # attr_accessor :tag_list

    include ImageTools
    include MainImage

    include BaseStates
    include HasMetaData
    include NestedSetMethods
    include CommonClassMethods

    include SimpleSort::Base
    include Pagination::Base

    include TheStorages::Storage
    include TheComments::Commentable
    include Notifications::LocalizedErrors

    include PublicationModeration
    include PublicationContentProcessing

    # Order is important for building of errors
    # Technical messages should be builded only
    # if we haven't user-friendly errors
    #
    ############################################
    # Order is important
    ############################################
    validates_presence_of :user, :title
    validates_presence_of :slug, if: ->{ errors.blank? }

    include FriendlyIdPack::Base
    ############################################
    # ~ Order is important
    ############################################
    before_validation :define_user_via_hub, :define_hub_state, on: :create
    before_save       :prepare_tags, :set_published_at
    before_save       :set_ugc_flag, on: :create
    after_create      :recalculate_hub_counters!

    paginates_per 24

    # relations
    belongs_to :hub
    belongs_to :user
    has_one :main_feed, as: :publication

    scope :publication_access, ->(user = nil) { user ? for_manage : published }
  end

  def comments_on?
    comments_switcher == 'on'
  end

  def comments_off?
    comments_switcher == 'off'
  end

  def root_hub
    hub.root_hub if hub
  end

  def update_attachment_fields att_name
    _self = self.class.find(self.id)

    %w[file_name content_type file_size updated_at].each do |field|
      field_name = "#{att_name}_#{field}"
      self.send "#{field_name}=", _self[field_name]
    end

    self
  end

  private

  def set_published_at
    # TODO: uncomments after release
    # self.published_at = self.created_at

    self.published_at = Time.now if published? && published_at.blank?
  end

  def define_user_via_hub
    self.user = hub.user if hub && user.blank?
  end

  def define_hub_state
    self.hub_state = hub.state if hub
  end

  def recalculate_hub_counters!
    hub.recalculate_pubs_counters! if hub
  end

  # User Generated Content
  def set_ugc_flag
    self.ugc = true unless user.admin?
  end

  def prepare_tags
    syms = Regexp.new '\.'
    tags = tag_list.to_s.mb_chars.gsub(syms, '_').to_s
    self.inline_tags = Sanitize.clean(tags, :elements => [])
  end
end
