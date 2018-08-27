class AddSuppressFromDisplayToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :suppress_from_display, :boolean, default: :false, null: false
    add_index :collections, :suppress_from_display
  end
end
