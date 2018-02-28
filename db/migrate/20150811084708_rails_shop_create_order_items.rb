class RailsShopCreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer    :order_id
      t.references :item, polymorphic: true

      t.integer    :amount
      t.decimal    :price,  precision: 8, scale: 2

      t.timestamps null: false
    end
  end
end
