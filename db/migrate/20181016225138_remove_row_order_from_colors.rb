class RemoveRowOrderFromColors < ActiveRecord::Migration
  def change
    remove_column :colors, :row_order
  end
end
