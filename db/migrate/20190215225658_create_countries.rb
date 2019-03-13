class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name
      t.string :iso_name
      t.string :iso, limit: 2
      t.string :iso3, limit: 3
      t.string :numcode, limit: 3
      t.integer :currency_id
      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end
    # add_foreign_key :countries,:currencies
  end
end
