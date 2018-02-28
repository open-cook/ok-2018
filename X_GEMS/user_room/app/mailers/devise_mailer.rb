class DeviseMailer < Devise::Mailer
  helper MailMarkupHelper
  include ::UserRoom::MailerSettingsConcern

  prepend_view_path 'app/views/ok2'
  layout "mailers/layout"

  before_action :set_attachments!

  # For default mailers
  def headers_for(action, opts)
    _headers = super
    _headers[:template_path].unshift('devise/mailer')
    _headers
  end

  # Additional Mailers
  # id = OnetimeLoginLink.last.id
  # DeviseMailer.mail_registration_request(id, '').deliver_now
  def mail_registration_request(id, callback_path = nil)
    reg_req  = EmailRegistrationRequest.find(id)
    @subject = "#{ env_prefix }Запрос на регистрацию на сайте OPEN-COOK.RU"

    @uid   = reg_req.uid
    @email = reg_req.email
    @callback_path = callback_path

    mail(to: @email, subject: @subject)
  end

  # id = OnetimeLoginLink.last.id
  # DeviseMailer.onetime_login_request(id, '').deliver_now
  def onetime_login_request(id, callback_path = nil)
    log_req  = OnetimeLoginLink.find(id)
    @subject = "#{ env_prefix }Одноразовая ссылка для входа на сайт OPEN-COOK.RU"

    @uid   = log_req.uid
    @email = log_req.email
    @callback_path = callback_path

    mail(to: @email, subject: @subject)
  end

  # DeviseMailer.new_user_created(user_id)
  def new_user_created(user_id)
    @user    = User.find(user_id)
    @email   = 'admin@open-cook.ru'
    @subject = "#{ env_prefix }Зарегистрирован новый пользователь"

    mail(to: @email, subject: @subject)
  end

  # def confirmation_instructions(record, token, opts={})
  #   super
  # end

  # def reset_password_instructions(record, token, opts={})
  #   super
  # end

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
