namespace :periodic_tasks do
  # rake periodic_tasks:destroy_expired_carts
  desc "Destroy expired and empty carts"
  task destroy_expired_carts: :environment do
    Cart.destroy_expired!
    puts "Expired carts destroyed"
  end
end