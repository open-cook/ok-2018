class CreateProductCategoryRelations < ActiveRecord::Migration
  def change
    create_table :product_category_relations do |t|
      t.belongs_to :product,          index: true
      t.belongs_to :product_category, index: true

      t.timestamps null: false
    end
  end
end
