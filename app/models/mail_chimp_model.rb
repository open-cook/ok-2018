module MailChimpModel
  API_KEY = "b0770afd740d2b5e917438730e3f7e17-us9"
  LIST_ID = "3aed240c1d"

  class << self
    def mail_chimp_connect
      begin
        @gb ||= Gibbon::API.new(MailChimpModel::API_KEY)
        @gb.timeout = 5
      rescue; end
    end

    def add email
      mail_chimp_connect

      begin
        @gb.lists.subscribe({
          email: { email: email },
          id: MailChimpModel::LIST_ID,
          double_optin: true # Подтверждение подписки

          # :merge_vars => {
          #   :FNAME => params[:first_name],
          #   :LNAME => params[:last_name]
          # },
        })

        [
          :ok,
          { flash: { info: "Для подтверждения подписки перейдите в почтовый ящик: <span class='nobr'>#{ email }</span>" } }
        ]
      rescue Gibbon::MailChimpError => e
        [
          e.code,
          { error: mc_message(e.message, e.code), code: e.code }
        ]
      end
    end

    def total
      mail_chimp_connect

      begin
        @gb.lists.members({id: MailChimpModel::LIST_ID})['total']
      rescue Exception => e
        # Gibbon::MailChimpError => e
        "???"
      end
    end

    def mc_message msg, code
      case code
        when 214
          "Данный Email не удалось добавить в список подписчиков"
        when -100
          "Вероятно Email содержит ошибку"
        else
          msg
      end
    end
  end
end
