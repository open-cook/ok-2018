class RailsShopLoggerMailer < ActionMailer::Base
  include ::RailsShop::MailerSettingsConcern

  prepend_view_path 'app/views/ok2'
  layout "mailers/layout"

  default bcc: 'admin@open-cook.ru'
  default template_path: 'rails_shop/mailers'

  before_action :set_attachments!

  # RailsShopLoggerMailer.product_added_to_cart(Cart.last.id, Product.last.id).deliver_now
  # RailsShopLoggerMailer.delay_for(2.seconds).product_added_to_cart(cart_id, product_id)
  def product_added_to_cart(cart_id, product_id)
    @cart    = Cart.find(cart_id)
    @product = Product.find(product_id)

    @to      = 'admin@open-cook.ru'
    @subject = "#{ env_prefix }LOGGER: Корзина #{ @cart.uid }"

    mail(to: @to, subject: @subject)
  end

  # RailsShopLoggerMailer.product_removed_from_cart(Cart.last.id, Product.last.id).deliver_now
  def product_removed_from_cart(cart_id, product_id)
    @cart    = Cart.find(cart_id)
    @product = Product.find(product_id)

    @to      = 'admin@open-cook.ru'
    @subject = "#{ env_prefix }LOGGER: Корзина #{ @cart.uid }"

    mail(to: @to, subject: @subject)
  end

  def selected_payment_system(order_id, payment_system_name)
    @to      = 'admin@open-cook.ru'
    @order   = Order.find(order_id)
    @subject = "#{ env_prefix }LOGGER: Оплата заказа #{ @order.uid }"
    @payment_system_name = payment_system_name

    mail(to: @to, subject: @subject)
  end

  private

  def set_attachments!
    @images = {
      'ok_logo.png'      => '/logos/ok_w350_h100.png',
      'ok_shop_logo.png' => '/logos/ok_shop_w350_h100.png'
    }

    @images.each_pair do |name, path|
      attachments.inline[name] = File.read("#{ Rails.root }/public/#{ path }")
    end
  end
end