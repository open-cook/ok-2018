module RailsShop
  module MailerSettingsConcern
    extend ActiveSupport::Concern

    included do
      def self.smtp?
        Settings.app.mailer.service == 'smtp'
      end

      # SomeMailer.test_mail.delivery_method.settings
      if smtp?
        default from: Settings.app.mailer.smtp.rails_shop.user_name

        def self.smtp_settings
          Settings.app.mailer.smtp.rails_shop.to_h
        end
      end
    end

    private

    def env_prefix
      'DEV => ' if Rails.env.development?
    end

    def smtp?
      Settings.app.mailer.service == 'smtp'
    end

    def default_from
      Settings.app.mailer.smtp.rails_shop.user_name if smtp?
    end
  end
end