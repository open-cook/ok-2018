class RailsShopAddCartItemsCount < ActiveRecord::Migration
  def change
    add_column :carts, :cart_items_counter, :integer, default: 0
  end
end
