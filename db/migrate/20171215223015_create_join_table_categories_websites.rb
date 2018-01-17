class CreateJoinTableCategoriesWebsites < ActiveRecord::Migration
  def change
    create_join_table :categories, :websites do |t|
      t.index [:category_id, :website_id]
      t.index [:website_id, :category_id]
    end
  end
end
