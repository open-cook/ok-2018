# rake the_audit:bots:recalc
namespace :the_audit do
  namespace :bots do
    # rake bots:recalc
    desc "Recalculate Audit Bot flags"

    task recalc: :environment do
      acount = Audit.count
      bsize  = 1000
      Audit.find_in_batches(batch_size: bsize).with_index do |group, index|
        group.each do |audit|
          bot_flag = TheAudit.is_bot?(audit.user_agent)

          if audit.bot != bot_flag
            audit.update_column(:bot, bot_flag)
            p "Updated: #{ audit.id }/#{ audit.user_agent }"
          end
        end

        p "#{ bsize * index.next }/#{ acount }"
      end
    end
  end
end
