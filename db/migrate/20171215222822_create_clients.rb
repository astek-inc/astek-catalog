class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :domain
      t.string :token
      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end
  end
end
