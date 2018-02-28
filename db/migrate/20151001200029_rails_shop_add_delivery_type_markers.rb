class RailsShopAddDeliveryTypeMarkers < ActiveRecord::Migration
  def change
    add_column :delivery_types, :delivery_kind, :string, default: :special
  end
end
