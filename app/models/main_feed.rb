class MainFeed < ActiveRecord::Base
  CLASSES = %w[ Recipe Post Interview Blog ]

  def self.suitable_for? pub
    CLASSES.include? pub.class.to_s
  end

  include SimpleSort::Base
  include Pagination::Base

  paginates_per 24

  belongs_to :publication, polymorphic: true

  scope :published, ->{ where(state: :published) }
  scope :moderated, ->{ where(moderation_state: :moderated) }
end
