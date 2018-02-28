class RailsShopDeliveryTypes < ActiveRecord::Migration
  def change
    create_table :delivery_types do |t|
      t.integer  :user_id

      t.string   :main_image_file_name
      t.string   :main_image_content_type
      t.integer  :main_image_file_size, default: 0
      t.datetime :main_image_updated_at

      t.string :title, default: ''

      t.decimal :price, precision: 8, scale: 2

      t.text :raw_intro, limit: 16777215
      t.text :intro,     limit: 16777215

      t.text :raw_content, limit: 16777215
      t.text :content,     limit: 16777215

      t.string :state, default: :draft
      t.timestamps null: false
    end
  end
end
