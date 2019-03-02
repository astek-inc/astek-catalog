class AddRowOrderToBackingTypes < ActiveRecord::Migration
  def change
    add_column :backing_types, :row_order, :integer
    add_index :backing_types, :row_order
  end
end
