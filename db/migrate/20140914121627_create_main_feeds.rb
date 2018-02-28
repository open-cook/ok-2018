class CreateMainFeeds < ActiveRecord::Migration
  def change
    create_table :main_feeds do |t|
      t.references :publication, polymorphic: true
      t.timestamps
    end
  end
end
