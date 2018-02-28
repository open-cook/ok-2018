# http://localhost:3000/rails/mailers
class MailerPreview < ActionMailer::Preview
  # DEVISE / USER ROOM

  def DEVISE_reset_password_instructions
    DeviseMailer.reset_password_instructions(User.last, {})
  end

  def DEVISE_confirmation_instructions
    DeviseMailer.confirmation_instructions(User.last, {})
  end

  def DEVISE_MailRegistrationRequest
    reg_req = EmailRegistrationRequest.last
    DeviseMailer.mail_registration_request(reg_req.id, callback_path = '/orders/09dfr12')
  end

  def DEVISE_OnetimeLoginRequest
    log_req = OnetimeLoginLink.last
    DeviseMailer.onetime_login_request(log_req.id, callback_path = '/orders/09dfr12')
  end

  def DEVISE_New_user_created
    user_id = User.first.id
    DeviseMailer.new_user_created(user_id)
  end

  # RAILS SHOP

  def RAILS_SHOP_Created
    order = Order.last || Order.new
    OrderMailer.created(order.id)
  end

  def RAILS_SHOP_Ready_to_payment
    order = Order.last || Order.new
    OrderMailer.ready_to_payment(order.id)
  end

  def RAILS_SHOP_Paid
    order = Order.last || Order.new
    OrderMailer.paid(order.id)
  end

  def RAILS_SHOP_Delivery
    order = Order.last || Order.new
    OrderMailer.delivery(order.id)
  end

  def RAILS_SHOP_Completed
    order = Order.last || Order.new
    OrderMailer.completed(order.id)
  end

  def RAILS_SHOP_Unexpected_transition
    order = Order.last || Order.new
    OrderMailer.unexpected_transition(order, [:paid, :draft])
  end

  def RAILS_SHOP_LOGGER_Product_added_to_cart
    cart    = Cart.filled.last
    product = cart.products.first.item

    RailsShopLoggerMailer.product_added_to_cart(cart.id, product.id)
  end

  def RAILS_SHOP_LOGGER_Product_removed_from_cart
    cart    = Cart.filled.last
    product = cart.products.first.item

    RailsShopLoggerMailer.product_removed_from_cart(cart.id, product.id)
  end

  def RAILS_SHOP_LOGGER_Selected_payment_system
    payment_system_name = 'qiwi'
    order = Order.last || Order.new
    RailsShopLoggerMailer.selected_payment_system(order.id, payment_system_name)
  end

  # APP TEST

  def APP_TEST_mailer
    TestMailer.test_mail
  end
end
