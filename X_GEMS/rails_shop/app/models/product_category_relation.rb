class ProductCategoryRelation < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  belongs_to :product_category

  validates :product, uniqueness: { scope: :product_category}
end
