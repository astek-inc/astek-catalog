class RemoveRowOrderFromProductTypes < ActiveRecord::Migration
  def change
    remove_column :product_types, :row_order
  end
end
