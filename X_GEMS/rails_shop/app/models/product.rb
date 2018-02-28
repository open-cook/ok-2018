class Product < ActiveRecord::Base
  include ImageTools

  include ::RailsShop::MainImage
  include ::RailsShop::StatesProcessing
  include ::RailsShop::ContentProcessing

  include ::TheStorages::Storage

  include ::SimpleSort::Base
  include ::Pagination::Base
  include ::Notifications::LocalizedErrors

  include HasMetaData

  validates_presence_of :user, :title
  validates_presence_of :slug, if: ->{ errors.blank? }
  validates :sku, uniqueness: true, if: ->{ sku.present? }

  include ::FriendlyIdPack::Base

  paginates_per 15

  belongs_to :user
  has_many :product_category_relations
  has_many :product_categories, through: :product_category_relations

  scope :in_stock, ->{ where('amount > 0') }
end
