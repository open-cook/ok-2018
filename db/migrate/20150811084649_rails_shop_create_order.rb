class RailsShopCreateOrder < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id

      t.string  :uid,    default: ''
      t.string  :state,  default: :draft
      t.decimal :price,  precision: 8, scale: 2

      t.string  :track_site, default: ''
      t.string  :track_code, default: ''

      t.timestamps null: false
    end
  end
end
