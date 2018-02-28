module MailerSettingsConcern
  extend ActiveSupport::Concern

  included do
    def self.smtp?
      %w[smtp letter_opener].include?(Settings.app.mailer.service)
    end

    # SomeMailer.test_mail.delivery_method.settings
    if smtp?
      default from: Settings.app.mailer.smtp.default.user_name

      def self.smtp_settings
        Settings.app.mailer.smtp.default.to_h
      end
    end
  end

  private

  def smtp?
    %w[smtp letter_opener].include?(Settings.app.mailer.service)
  end

  def default_from
    Settings.app.mailer.smtp.default.user_name if smtp?
  end
end
