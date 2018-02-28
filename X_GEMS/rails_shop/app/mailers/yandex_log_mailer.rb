class YandexLogMailer < ActionMailer::Base
  include ::RailsShop::MailerSettingsConcern

  # layout "rails_shop/layouts/mailer"
  # default bcc: 'admin@open-cook.ru'

  default template_path: 'rails_shop/mailers/yandex_kassa'

  # YandexLogMailer.log_params('Check', { ... }).deliver_now
  def log_params(name, data = {})
    @name = name
    @data = data
    @data.try(:[], :params).try(:delete, :commit)

    mail(
      to:            'zykin-ilya@ya.ru',
      subject:       "Яндекс.Касса / Платежная проверка: #{ @name }"
    )
  end
end