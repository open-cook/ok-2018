class AddMainImageToShopItems < ActiveRecord::Migration
  def change
    [:products, :product_categories].each do |table_name|
      change_table table_name do |t|
        # MAIN IMAGE | paperclip
        t.string   :main_image_file_name
        t.string   :main_image_content_type
        t.integer  :main_image_file_size, default: 0
        t.datetime :main_image_updated_at
      end
    end
  end
end
