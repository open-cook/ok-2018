class RailsShopCreateCart < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :user_id
      t.string  :uid, default: ''
      t.timestamps null: false
    end
  end
end
