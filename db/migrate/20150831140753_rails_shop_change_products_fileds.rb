class RailsShopChangeProductsFileds < ActiveRecord::Migration
  def change
    rename_column :products, :article_number, :sku
  end
end
