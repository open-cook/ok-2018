class RailsShopAddFieldsToDeliveryType < ActiveRecord::Migration
  def change
    change_table :delivery_types do |t|
      t.boolean  :default_option,     default: false
      t.boolean  :blocking_cart_item, default: false
      t.string   :required_contacts,  default: :default
    end
  end
end
