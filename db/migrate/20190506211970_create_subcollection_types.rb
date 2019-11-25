class CreateSubcollectionTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :subcollection_types do |t|
      t.string :name
      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end
  end
end
