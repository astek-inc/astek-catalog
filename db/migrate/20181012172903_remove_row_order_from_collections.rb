class RemoveRowOrderFromCollections < ActiveRecord::Migration
  def change
    remove_column :collections, :row_order
  end
end
