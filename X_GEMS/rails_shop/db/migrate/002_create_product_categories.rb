class CreateProductCategories < ActiveRecord::Migration
  def change
    create_table :product_categories do |t|
      t.integer  :user_id

      t.string :slug,        default: ''
      t.string :short_id,    default: ''
      t.string :friendly_id, default: ''

      t.boolean :optgroup, default: false

      t.string :title, default: ''

      t.text :raw_intro, limit: 16777215
      t.text :intro,     limit: 16777215

      t.text :raw_content, limit: 16777215
      t.text :content,     limit: 16777215

      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth, default: 0

      t.string :state, default: :draft

      t.integer :products_draft_count,     default: 0
      t.integer :products_published_count, default: 0
      t.integer :products_deleted_count,   default: 0

      t.datetime   :published_at, null: false
      t.timestamps null: false
    end
  end
end
