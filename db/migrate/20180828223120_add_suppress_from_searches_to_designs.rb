class AddSuppressFromSearchesToDesigns < ActiveRecord::Migration
  def change
    add_column :designs, :suppress_from_searches, :boolean, default: false
    add_index :designs, :suppress_from_searches
  end
end
