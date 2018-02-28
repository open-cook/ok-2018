class RailsShopCreateDeliveryAddresses < ActiveRecord::Migration
  def change
    create_table :delivery_addresses do |t|

      t.string  :title, default: ''

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

      t.timestamps null: false
    end
  end
end
