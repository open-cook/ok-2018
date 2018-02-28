class RailsShopAddDeliveryDataToOrder < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.string  :email, default: ''
      t.string  :phone, default: ''

      t.string  :name,       default: ''
      t.string  :patronymic, default: ''
      t.string  :surname,    default: ''

      t.string  :country,      default: ''
      t.string  :region,       default: ''
      t.string  :city,         default: ''
      t.string  :postcode,     default: ''
      t.string  :street,       default: ''
      t.string  :house_number, default: ''
      t.text    :delivery_comment
    end
  end
end
