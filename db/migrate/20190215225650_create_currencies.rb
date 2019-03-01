class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :code, limit: 3
      t.string :symbol
      t.string :symbol_position
      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end
  end
end
