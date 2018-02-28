class ProductCategory < ActiveRecord::Base
  include ImageTools

  include ::RailsShop::MainImage
  include ::RailsShop::StatesProcessing
  include ::RailsShop::ContentProcessing

  include ::SimpleSort::Base
  include ::Pagination::Base
  include ::Notifications::LocalizedErrors

  include PublicationContentProcessing

  validates_presence_of :user, :title
  validates_presence_of :slug, if: ->{ errors.blank? }

  include ::FriendlyIdPack::Base

  paginates_per 15

  belongs_to :user
  has_many :product_category_relations
  has_many :products, through: :product_category_relations
end
