class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :name, index: true
      t.string :presentation
      t.string :klass_scope, index: true
      t.timestamps null: false
    end
  end
end
