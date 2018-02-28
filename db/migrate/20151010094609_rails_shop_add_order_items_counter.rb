class RailsShopAddOrderItemsCounter < ActiveRecord::Migration
  def change
    add_column :orders, :order_items_counter, :integer, default: 0
  end
end
