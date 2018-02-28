# required by config/initializers/acts_as_taggable_on.rb
# restart web server after change
class ActsAsTaggableOn::Tagging
  include SimpleSort::Base
  include Pagination::Base

  paginates_per 24

  belongs_to :published_pub,
    ->(o) { where(state: :published) },
    polymorphic:  true,
    foreign_key:  :taggable_id,
    foreign_type: :taggable_type
end
