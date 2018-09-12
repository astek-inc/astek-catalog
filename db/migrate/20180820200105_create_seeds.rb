class CreateSeeds < ActiveRecord::Migration
  def change
    create_table :seeds do |t|
      t.string :filename, unique: true
      t.timestamps null: false
    end
  end
end
