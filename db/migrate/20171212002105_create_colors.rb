class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors do |t|
      t.string :name, unique: true
      t.timestamps null: false
    end
  end
end
