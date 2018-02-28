class CreatePublications < ActiveRecord::Migration
  def change
    [:pages, :posts, :hubs].each do |table_name|
      create_table table_name do |t|
        t.integer :user_id
        t.integer :hub_id

        # Base
        t.string :title, default: ''

        t.text   :raw_intro
        t.text   :intro

        t.text   :raw_content
        t.text   :content

        # denormalization
        t.string :hub_state, default: :draft
        t.string :legacy_url

        t.string :inline_tags, default: ''

        # DateTime
        t.datetime :published_at
        t.timestamps
      end
    end
  end
end
