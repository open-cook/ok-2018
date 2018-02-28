class AddFieldsToProduct < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.string  :price_text,     default: ''
      t.string  :special_marker, default: ''
      t.integer :discount,       default: 0
    end
  end
end
