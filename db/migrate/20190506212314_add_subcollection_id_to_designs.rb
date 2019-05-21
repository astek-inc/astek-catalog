class AddSubcollectionIdToDesigns < ActiveRecord::Migration[5.2]
  def change
    add_column :designs, :subcollection_id, :integer
    add_foreign_key :designs, :subcollections
  end
end
