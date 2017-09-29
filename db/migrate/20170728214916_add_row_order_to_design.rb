class AddRowOrderToDesign < ActiveRecord::Migration
  def change
    add_column :designs, :row_order, :integer
    add_index :designs, :row_order
  end
end
