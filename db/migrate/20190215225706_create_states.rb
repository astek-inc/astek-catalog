class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name
      t.string :abbr
      t.integer :country_id
      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end
    add_foreign_key :states,:countries
  end
end
