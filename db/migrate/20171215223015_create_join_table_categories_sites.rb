class CreateJoinTableCategoriesSites < ActiveRecord::Migration
  def change
    create_join_table :categories, :sites do |t|
      t.index [:category_id, :site_id]
      t.index [:site_id, :category_id]
    end
  end
end
