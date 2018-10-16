class RemoveRowOrderFromSubstrates < ActiveRecord::Migration
  def change
    remove_column :substrates, :row_order
  end
end
