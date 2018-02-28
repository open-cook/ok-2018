class User < ActiveRecord::Base
  include UserRoom::User
  include RailsShop::User

  include HasMetaData

  include TheComments::User
  include TheComments::Commentable

  include TheStorages::Storage
  include TheStorages::HasAttachedFiles
  include Notifications::LocalizedErrors

  def to_param; self.login end

  def oauth_default_email_domain
    'open-cook.ru'
  end

  # Relations
  %w[ hubs pages posts blogs recipes interviews hots ].each do |model_name|
    has_many model_name.to_sym
  end

  class << self
    def root
      @@root ||= User.first
    end
  end

  def admin?
    self == User.root
  end

  def moderator?(param = nil)
    admin?
  end

  def owner? obj
    return id == obj.id      if obj.is_a?(User)
    return id == obj.user_id if obj.respond_to?(:user_id)
    false
  end

  # TheComments methods
  def comments_admin?
    self == User.root
  end

  def comments_moderator? comment
    admin? || id == comment.holder_id
  end

  def commentable_title
    login
  end

  def commentable_path
    [self.class.to_s.tableize, login].join('/')
  end
  # ~ TheComments methods

  def recalculate_all_attached_files!
    # Recalculate all user counters here
  end

  # Select an available hubs
  def available_hubs object = nil
    return Hub.none if object.nil?

    ctrl_name = object.ctrl_name                        # posts
    scope = ctrl_name.blank? ? :all : [:of_, ctrl_name] # [:of_, :posts]

    return Hub.send(*scope).for_manage if admin?        # Hub.of_posts

    # section = role.to_hash.try(:[], 'available_hubs')
    # return Hub.none if section.blank?

    keys = section.select{|k, v| v == true }.keys
    keys.map!{|item| item.to_slug_param }

    Hub.friendly_where(keys).published_set.send(*scope)
  end

  # articles, blogs, pages
  def editable_hubs_for section_name = nil
    return Hub.none unless section_name

    top_hub = Hub.where(slug: section_name).first
    return Hub.none unless top_hub

    pub_scope = admin? ? :published : :all
    top_hub.self_and_descendants.send(pub_scope)
  end

  private
end
