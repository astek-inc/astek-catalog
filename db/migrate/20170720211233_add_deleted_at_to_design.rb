class AddDeletedAtToDesign < ActiveRecord::Migration
  def change
    add_column :designs, :deleted_at, :datetime
    add_index :designs, :deleted_at
  end
end
