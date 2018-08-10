class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.string :name
      t.string :domain
      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end
  end
end
