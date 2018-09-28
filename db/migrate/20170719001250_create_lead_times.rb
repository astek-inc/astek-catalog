class CreateLeadTimes < ActiveRecord::Migration
  def change
    create_table :lead_times do |t|
      t.string :name, unique: true
      t.text :description
      t.integer :row_order, index: true
      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end
  end
end
