class RailsShopChangeOrdersFields < ActiveRecord::Migration
  def change
    rename_column :orders, :name, :full_name

    remove_column :orders, :surname
    remove_column :orders, :patronymic
  end
end
