class RemoveRowOrderFromBackingTypes < ActiveRecord::Migration
  def change
    remove_column :backing_types, :row_order
  end
end
