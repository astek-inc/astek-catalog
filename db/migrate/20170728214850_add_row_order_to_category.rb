class AddRowOrderToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :row_order, :integer
    add_index :categories, :row_order
  end
end
