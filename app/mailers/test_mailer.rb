class TestMailer < ActionMailer::Base
  include MailerSettingsConcern

  # TestMailer.test_mail.deliver_now
  def test_mail
    set_attachments!

    mail(
      to: 'zykin-ilya@yandex.ru',
      from: default_from,
      subject: "Тестовое письмо",
      template_path: "mailers",
      template_name: "test"
    )
  end

  private

  def set_attachments!
    @images = {
      'ok_100x100.png' => '/default_images/ok_100x100.png'
    }

    @images.each_pair do |k, v|
      attachments.inline[k] = File.read("#{ Rails.root }/public/#{ v }")
    end
  end
end
