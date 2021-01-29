class AddRowOrderToStockItems < ActiveRecord::Migration[5.2]
  def change
    add_column :stock_items, :row_order, :integer
    add_index :stock_items, :row_order
  end
end
