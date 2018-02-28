class AddStatesToMainFeed < ActiveRecord::Migration
  def change
    add_column :main_feeds, :state, :string, default: :draft
    add_column :main_feeds, :moderation_state, :string, default: :unmoderated
  end
end
