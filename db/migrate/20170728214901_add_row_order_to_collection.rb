class AddRowOrderToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :row_order, :integer
    add_index :collections, :row_order
  end
end
