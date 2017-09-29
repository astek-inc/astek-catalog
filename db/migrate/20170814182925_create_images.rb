class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :file
      t.string :type, index: true
      t.integer :owner_id, index: true
      t.integer :row_order, index: true
      t.timestamps null: false
      t.datetime :deleted_at, index: true
    end
  end
end
