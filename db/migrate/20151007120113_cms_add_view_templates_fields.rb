class CmsAddViewTemplatesFields < ActiveRecord::Migration
  def change
    [:posts, :pages, :recipes, :blogs, :hots, :interviews].each do |table_name|
      change_table table_name do |t|
        t.string :view_layout,   default: ''
        t.string :view_template, default: ''
      end
    end
  end
end
