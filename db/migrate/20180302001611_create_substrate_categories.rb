class CreateSubstrateCategories < ActiveRecord::Migration
  def change
    create_table :substrate_categories do |t|
      t.string :name
      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end
  end
end
