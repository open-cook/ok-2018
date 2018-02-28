class EmailRegistrationRequest < ActiveRecord::Migration
  def change
    create_table :email_registration_requests do |t|
      t.string  :uid,    default: ''
      t.string  :email,  default: ''

      t.timestamps null: false
    end
  end
end
