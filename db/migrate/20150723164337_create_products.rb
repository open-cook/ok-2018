class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer  :user_id

      t.string :slug,        default: ''
      t.string :short_id,    default: ''
      t.string :friendly_id, default: ''

      t.string  :title,           default: ''
      t.string  :dimensions,      default: ''
      t.string  :article_number,  default: ''
      t.integer :amount, default: 0
      t.integer :weight, default: 0
      t.decimal :price,  precision: 8, scale: 2 #, null: false, default: 0.0

      t.text :equipment

      t.text :raw_intro, limit: 16777215
      t.text :intro,     limit: 16777215

      t.text :raw_content, limit: 16777215
      t.text :content,     limit: 16777215

      t.string :state, default: :draft

      t.integer  :show_count,  default: 0
      t.string   :inline_tags, default: ''

      t.datetime   :published_at, null: true
      t.timestamps null: false
    end
  end
end
