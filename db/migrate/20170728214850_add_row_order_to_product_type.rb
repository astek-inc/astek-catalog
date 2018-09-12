class AddRowOrderToProductType < ActiveRecord::Migration
  def change
    add_column :product_types, :row_order, :integer
    add_index :product_types, :row_order
  end
end
