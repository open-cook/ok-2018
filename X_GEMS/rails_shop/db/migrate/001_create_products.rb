class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer  :user_id
      t.integer  :product_category_id

      t.string   :slug,        default: ''
      t.string   :short_id,    default: ''
      t.string   :friendly_id, default: ''

      t.string  :title,  default: ''
      t.integer :amount, default: 0
      t.string  :sku, default: ''
      t.decimal :price,  precision: 8, scale: 2

      t.text :equipment, default: ''

      t.text :raw_intro, limit: 16777215
      t.text :intro,     limit: 16777215

      t.text :raw_content, limit: 16777215
      t.text :content,     limit: 16777215

      t.string :state,                  default: :draft
      t.string :product_category_state, default: :draft

      t.integer  :show_count,  default: 0
      t.string   :inline_tags, default: ''

      t.datetime   :published_at, null: false
      t.timestamps null: false
    end
  end
end
