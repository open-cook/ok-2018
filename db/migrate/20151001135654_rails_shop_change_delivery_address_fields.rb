class RailsShopChangeDeliveryAddressFields < ActiveRecord::Migration
  def change
    rename_column :delivery_addresses, :name, :full_name

    remove_column :delivery_addresses, :surname
    remove_column :delivery_addresses, :patronymic
  end
end
