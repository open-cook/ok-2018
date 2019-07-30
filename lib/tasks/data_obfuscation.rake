# frozen_string_literal: true

require 'bcrypt'
require 'faker'

namespace :data_obfuscation do
  TEMP_FILES_PATH = "#{Rails.root}/tmp"

  task run: :environment do
    Rake::Task['data_obfuscation:db_dump'].invoke

    ThinkingSphinx::Callbacks.suspend!

    Rake::Task['data_obfuscation:run_obfuscation'].invoke

    ThinkingSphinx::Callbacks.resume!
  end

  task run_obfuscation: :environment do
    system('RAILS_ENV=temporarily rake db:drop')
    system('RAILS_ENV=temporarily rake db:create')

    system('RAILS_ENV=temporarily rake data_obfuscation:restore')

    Rake::Task['data_obfuscation:obfuscation'].invoke

    system('RAILS_ENV=temporarily rake data_obfuscation:db_obfuscated_dump')
    system('RAILS_ENV=temporarily rake data_obfuscation:archive_uploads')
    system('RAILS_ENV=temporarily rake data_obfuscation:delete_full_dump')
  end

  task db_dump: :environment do
    with_config do |app, host, db, user|
      user.present? ? user = '--username ' + user : nil
      host.present? ? host = '--host ' + host : nil

      system "pg_dump #{host} #{user} --clean --no-owner --no-acl --format=c #{db} > #{TEMP_FILES_PATH}/#{app}.dump"
      puts "database dump created at #{TEMP_FILES_PATH}/#{app}.dump"
    end
  end

  task db_obfuscated_dump: :environment do
    with_config do |app, host, db, user|
      user.present? ? user = '--username ' + user : nil
      host.present? ? host = '--host ' + host : nil

      system "pg_dump #{host} #{user} --clean --no-owner --no-acl --format=c #{db} > #{TEMP_FILES_PATH}/#{app}_obfuscated.dump"
      puts "obfuscated database dump created at #{TEMP_FILES_PATH}/#{app}_obfuscated.dump"
    end
  end

  task restore: :environment do
    cmd = nil

    with_config do |app, _host, db, _user|
      cmd = "pg_restore --verbose --clean --no-owner --no-acl --dbname #{db} #{TEMP_FILES_PATH}/#{app}.dump"
    end

    puts cmd
    system cmd
  end

  task delete_full_dump: :environment do
    with_config do |app, _host, _db, _user|
      system "rm #{TEMP_FILES_PATH}/#{app}.dump" if File.exist?("#{TEMP_FILES_PATH}/#{app}_obfuscated.dump")
    end
  end

  task obfuscation: :environment do
    ActiveRecord::Base.establish_connection(:temporarily)

    i = 1

    User.find_each do |user|
      user.update_columns(
        username: Faker::Name.name,
        encrypted_password: BCrypt::Password.create('password'),
        email: "user_#{i}@example.com",
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
      i += 1
    end

    puts 'Passwords and social networks obfuscated!'

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

    puts 'Orders obfuscated!'

    Credential.update_all(access_token: nil, access_token_secret: nil, uid: '1')

    puts 'Credentials obfuscated!'

    Obfuscation.delete_half(Recipe)
    Obfuscation.delete_half(Post)
    Obfuscation.delete_half(Blog)
    Obfuscation.delete_half(Hot)
    Obfuscation.delete_half(Interview)

    puts '50% of data deleted'
  end

  task archive_uploads: :environment do
    with_config do |app|
      paths = ''
      path_to_obfuscated_dump = " #{TEMP_FILES_PATH}/#{app}_obfuscated.dump"

      paths = Obfuscation.create_links(Post, paths)
      paths = Obfuscation.create_links(Product, paths)
      paths = Obfuscation.create_links(Blog, paths)
      paths = Obfuscation.create_links(Interview, paths)
      paths = Obfuscation.create_links(Hot, paths)
      paths = Obfuscation.create_links(Recipe, paths)
      paths = Obfuscation.create_links(Page, paths)

      system "tar -czf obfuscated_data.tar.gz #{paths} #{path_to_obfuscated_dump}"
    end

    puts 'obfuscated_data.tar.gz created!'
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
