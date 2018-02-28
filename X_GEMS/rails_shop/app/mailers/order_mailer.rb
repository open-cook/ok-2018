class OrderMailer < ActionMailer::Base
  include ::RailsShop::MailerSettingsConcern

  prepend_view_path 'app/views/ok2'
  layout "mailers/layout"

  default from: 'admin@open-cook.ru'
  default bcc: 'admin@open-cook.ru'
  default template_path: 'rails_shop/mailers'

  before_action :set_attachments!

  # OrderMailer.unexpected_transition(Order.last, %w[paid draft]).deliver_now
  # OrderMailer.delay_for(2.seconds).unexpected_transition(Order.last, %w[paid draft])

  def created(order_id)
    @order   = Order.find(order_id)

    @subject = I18n.t(:created, scope: %w[ rails_shop orders state_changed ], uid: @order.uid.upcase)
    @subject = "#{ env_prefix }#{ @subject }"

    @to = 'admin@open-cook.ru'

    if user_email = @order.user.try(:email)
      if user_email.present? && user_email.to_s.match(/@/)
        @to = user_email
      end
    end

    mail(to: @to, subject: @subject)
  end

  def moderation(order_id)
    @to      = 'zykin-ilya@ya.ru'
    @order   = Order.find(order_id)

    @subject = I18n.t(:moderation, scope: %w[ rails_shop orders state_changed ], uid: @order.uid.upcase)
    @subject = "#{ env_prefix }#{ @subject }"

    @to  = 'admin@open-cook.ru'
    @to = @order.email if @order.has_valid_email?

    mail(to: @to, subject: @subject)
  end

  def ready_to_payment(order_id)
    @order   = Order.find(order_id)

    @subject = I18n.t(:ready_to_payment, scope: %w[ rails_shop orders state_changed ], uid: @order.uid.upcase)
    @subject = "#{ env_prefix }#{ @subject }"

    @to = 'admin@open-cook.ru'
    @to = @order.email if @order.has_valid_email?

    mail(to: @to, subject: @subject)
  end

  def paid(order_id)
    @order   = Order.find(order_id)

    @subject = I18n.t(:paid, scope: %w[ rails_shop orders state_changed ], uid: @order.uid.upcase)
    @subject = "#{ env_prefix }#{ @subject }"

    @to = 'admin@open-cook.ru'
    @to = @order.email if @order.has_valid_email?

    mail(to: @to, subject: @subject)
  end

  def delivery(order_id)
    @order   = Order.find(order_id)

    @subject = I18n.t(:delivery, scope: %w[ rails_shop orders state_changed ], uid: @order.uid.upcase)
    @subject = "#{ env_prefix }#{ @subject }"

    @to = 'admin@open-cook.ru'
    @to = @order.email if @order.has_valid_email?

    mail(to: @to, subject: @subject)
  end

  def completed(order_id)
    @order   = Order.find(order_id)

    @subject = I18n.t(:completed, scope: %w[ rails_shop orders state_changed ], uid: @order.uid.upcase)
    @subject = "#{ env_prefix }#{ @subject }"

    @to = 'admin@open-cook.ru'
    @to = @order.email if @order.has_valid_email?

    mail(to: @to, subject: @subject)
  end

  def unexpected_transition(order_id, state_changed)
    @order = Order.find(order_id)

    @subject = I18n.t(:unexpected_transition, scope: %w[ rails_shop orders state_changed ], uid: @order.uid.upcase)
    @subject = "#{ env_prefix }#{ @subject }"

    @state_changed = state_changed
    @to = 'admin@open-cook.ru'

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
