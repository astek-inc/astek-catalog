class CreateSubcollections < ActiveRecord::Migration[5.2]
  def change
    create_table :subcollections do |t|
      t.string :name, null: false
      t.integer :subcollection_type_id, null: false
      t.integer :collection_id
      t.timestamps null: false
    end
  end
end
