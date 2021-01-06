# frozen_string_literal: true

require 'bcrypt'
require 'faker'

def script_message message
  puts ('*'*50).red
  puts message
  puts ('*'*50).red
  sleep 1
end

TEMP_FILES_PATH = "#{Rails.root}/tmp"
OBFUSCATED_DUMP_NAME = "open_cook-obfuscated.dump"

DEV_DB_DUMP = "#{TEMP_FILES_PATH}/ok_dev.dump"
OBFUSCATION_DIR = "#{TEMP_FILES_PATH}/obfuscation"
OBFUSCATED_DUMP = "#{TEMP_FILES_PATH}/#{OBFUSCATED_DUMP_NAME}"
OBFUSCATED_ARCHIVE = "#{TEMP_FILES_PATH}/obfuscated_data.tar.gz"

UNTAR_DIR = "#{TEMP_FILES_PATH}/untar"
DB_TO_RESTORE = "#{UNTAR_DIR}/#{OBFUSCATED_DUMP_NAME}"

namespace :data_obfuscation do
  task run: :environment do
    Rake::Task['data_obfuscation:db_dump'].invoke

    ThinkingSphinx::Callbacks.suspend!

    Rake::Task['data_obfuscation:run_obfuscation'].invoke

    ThinkingSphinx::Callbacks.resume!

    script_message('Obfuscation sucessufully done')
  end

  task run_obfuscation: :environment do
    system('RAILS_ENV=temporarily rake db:drop')
    system('RAILS_ENV=temporarily rake db:create')
    system('RAILS_ENV=temporarily rake data_obfuscation:restore')

    Rake::Task['data_obfuscation:obfuscation'].invoke

    system('RAILS_ENV=temporarily rake data_obfuscation:db_obfuscated_dump')
    system('RAILS_ENV=temporarily rake data_obfuscation:archive_uploads')
    system('rake data_obfuscation:cleanup_tmp_files')
  end


  task unzip: :environment do
    script_message('Unzipping the archive')
    system("mkdir #{UNTAR_DIR}")
    system("tar xvzf #{OBFUSCATED_ARCHIVE} -C #{UNTAR_DIR}")
  end

  task setup: :environment do
    db = Rails.configuration.database_configuration['development']
    db_name = db['database']

    script_message('Cleaning development database')
    system('RAILS_ENV=development rake db:drop')
    system('RAILS_ENV=development rake db:create')

    script_message('Preparing to restore')

    system('RAILS_ENV=development rake data_obfuscation:unzip')

    script_message('Restore Obfuscated DB')
    system("pg_restore --verbose --clean --no-owner --no-acl --dbname #{db_name} #{DB_TO_RESTORE}")
    system('RAILS_ENV=development rake db:migrate')
    script_message('Obfuscated DB is restored')

    script_message('Restore Uploaded files')
    system("cp -R #{UNTAR_DIR}/public/uploads public")
    script_message('Uploaded filed are restored')

    system('rake data_obfuscation:cleanup_tmp_files')
  end

  task db_dump: :environment do
    script_message("Path to save obfuscated data: " + TEMP_FILES_PATH.yellow)

    with_config do |app, host, db, user|
      user.present? ? user = '--username ' + user : nil
      host.present? ? host = '--host ' + host : nil

      system "pg_dump #{host} #{user} --clean --no-owner --no-acl --format=c #{db} > #{DEV_DB_DUMP}"
      puts "database dump created at #{DEV_DB_DUMP}"
    end
  end

  task db_obfuscated_dump: :environment do
    with_config do |app, host, db, user|
      user.present? ? user = '--username ' + user : nil
      host.present? ? host = '--host ' + host : nil

      system "pg_dump #{host} #{user} --clean --no-owner --no-acl --format=c #{db} > #{OBFUSCATED_DUMP}"

      script_message("obfuscated database dump created at #{OBFUSCATED_DUMP}")
    end
  end

  task restore: :environment do
    cmd = nil

    with_config do |app, _host, db, _user|
      cmd = "pg_restore --verbose --clean --no-owner --no-acl --dbname #{db} #{DEV_DB_DUMP}"
    end

    puts cmd
    system cmd
  end

  task cleanup_tmp_files: :environment do
    script_message("Cleaning up TMP files and DIRs: #{DEV_DB_DUMP}, #{OBFUSCATED_DUMP}, #{OBFUSCATION_DIR}, #{UNTAR_DIR}")
    system "rm #{DEV_DB_DUMP}"
    system "rm #{OBFUSCATED_DUMP}"
    system "rm -rf #{OBFUSCATION_DIR}"
    system "rm -rf #{UNTAR_DIR}"
  end

  task obfuscation: :environment do
    ActiveRecord::Base.establish_connection(:temporarily)

    i = 1

    def user_email user
      user.id == 1 ? user.email : "user_#{user.id}@open-cook.dev"
    end

    User.find_each do |user|
      user.update_columns(
        encrypted_password: BCrypt::Password.create('password'),
        email: user_email(user),
        vk_addr: '',
        ok_addr: '',
        tw_addr: '',
        fb_addr: '',
        gp_addr: '',
        ig_addr: '',
        pt_addr: '',
        yt_addr: '',
        vm_addr: '',
        sh_addr: ''
      )
    end

    script_message('Passwords and social networks obfuscated!')

    Order.find_each do |order|
      order.update_columns(
        email: Faker::Internet.free_email,
        phone: Faker::PhoneNumber.cell_phone,
        full_name: Faker::Name.name,
        country: Faker::Address.country,
        region: Faker::Address.state,
        city: Faker::Address.city,
        postcode: Faker::Address.postcode,
        street: Faker::Address.street_name,
        house_number: Faker::Address.building_number,
        delivery_comment: Faker::Lorem.sentence
      )
    end

    i = 1

    EmailRegistrationRequest.find_each do |email|
      email.update_columns(email: "user_#{i}@example.com")
      i += 1
    end

    Comment.find_each do |comment|
      comment.update_columns(ip: 'localhost', contacts: Faker::Internet.free_email)
    end

    SystemMessage.destroy_all

    script_message('Orders obfuscated!')

    Credential.update_all(access_token: nil, access_token_secret: nil, uid: '1')

    script_message('Credentials obfuscated!')

    Obfuscation.delete_half(Recipe)
    Obfuscation.delete_half(Post)
    Obfuscation.delete_half(Blog)
    Obfuscation.delete_half(Hot)
    Obfuscation.delete_half(Interview)

    # Update basic counters
    Hub.all.map{ |hub| hub.recalculate_pubs_counters! }

    script_message('50% of data deleted')
  end

  task archive_uploads: :environment do
    with_config do |app|
      paths = ''

      paths = Obfuscation.create_links(Post, paths)
      paths = Obfuscation.create_links(Product, paths)
      paths = Obfuscation.create_links(Blog, paths)
      paths = Obfuscation.create_links(Interview, paths)
      paths = Obfuscation.create_links(Hot, paths)
      paths = Obfuscation.create_links(Recipe, paths)
      paths = Obfuscation.create_links(Page, paths)

      system "mkdir -p #{OBFUSCATION_DIR}"

      paths.split(' ').map do |path|
        system "mkdir -p #{OBFUSCATION_DIR}/#{path}"
        system "cp -R #{path} #{OBFUSCATION_DIR}/#{path}"
      end

      # Store some additional folders
      %w[banners default root users watermarks].each do |path|
        system "cp -R public/uploads/#{path} #{OBFUSCATION_DIR}/public/uploads/#{path}"
      end

      script_message('Files are copied')

      system "cp #{OBFUSCATED_DUMP} #{OBFUSCATION_DIR}"
      system "tar -czf #{OBFUSCATED_ARCHIVE} -C #{OBFUSCATION_DIR} ."
    end

    script_message("#{OBFUSCATED_ARCHIVE} created!")
  end

  module Obfuscation
    def delete_half(model)
      records_ids = model.pluck(:id).find_all(&:even?)

      model.where(id: records_ids).destroy_all
      MainFeed.where(publication_id: records_ids, publication_type: model).destroy_all
    end

    def create_links(class_name, paths)
      url = 'public/uploads/storages'

      class_name.find_each do |object|
        paths += " #{url}/#{class_name.to_s.downcase}/#{object.id}/"
      end

      paths
    end

    module_function :delete_half, :create_links
  end

  private

  def with_config
    yield Rails.application.class.parent_name.underscore,

    ActiveRecord::Base.connection_config[:host],
    ActiveRecord::Base.connection_config[:database],
    ActiveRecord::Base.connection_config[:username]
  end
end
