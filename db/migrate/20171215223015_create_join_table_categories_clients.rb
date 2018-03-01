class CreateJoinTableCategoriesClients < ActiveRecord::Migration
  def change
    create_join_table :categories, :clients do |t|
      t.index [:category_id, :client_id]
      t.index [:client_id, :category_id]
    end
  end
end
