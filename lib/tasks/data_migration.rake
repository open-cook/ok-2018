# MYSQL_CONNECTION_PARAMS = {
#   :adapter  => "mysql2",
#   :host     => "localhost",
#
#   :username => "the-teacher",
#   :database => "open_cook_dev",
#   :password => "qwerty",
#   :encoding => "utf8"
# }
#
# PSQL_CONNECTION_PARAMS = {
#   :adapter  => "postgresql",
#   :encoding => "unicode",
#   :host     => "localhost",
#
#   :username => "the-teacher",
#   :database => "open_cook_dev",
#   :password => ""
# }

# RAILS_ENV=production rake data_migration:run
namespace :data_migration do
  task run: :environment do
    tables = ActiveRecord::Base.connection.tables.sort - ['schema_migrations', 'audits']

    tables.each do |table_name|
      eval %Q(
        class ::Old#{table_name.classify} < ActiveRecord::Base
          establish_connection MYSQL_CONNECTION_PARAMS
          self.table_name = "#{table_name}"
        end

        class ::New#{table_name.classify} < ActiveRecord::Base
          establish_connection PSQL_CONNECTION_PARAMS
          self.table_name = "#{table_name}"
        end
      )

      old_class = "old_#{table_name}".classify.constantize
      new_class = "new_#{table_name}".classify.constantize

      puts "#{old_class} => #{new_class}".yellow

      all_items = old_class.all
      all_count = all_items.count

      all_items.each_with_index do |old_item, index|
        attrs = {}

        old_class.column_names.each do |column|
          attrs[column] = old_item[column]
        end

        new_class.new(attrs).save(validate: false)
        puts "#{index.next} of #{all_count}"
      end

      max_id = (new_class.maximum(:id) || 0).next
      ActiveRecord::Base.connection.execute "ALTER SEQUENCE #{table_name}_id_seq RESTART WITH #{ max_id }"
      puts "#{table_name} => #{max_id}"
    end
  end
end
