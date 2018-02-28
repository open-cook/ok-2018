class RailsShopAddOrderPrices < ActiveRecord::Migration
  def change
      rename_column :orders, :price, :total_price

      change_table :orders do |t|
        t.decimal :products_price,  precision: 8, scale: 2
        t.decimal :delivery_price,  precision: 8, scale: 2
        t.decimal :discount,        precision: 8, scale: 2
      end
  end
end
