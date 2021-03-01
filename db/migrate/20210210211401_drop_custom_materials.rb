class DropCustomMaterials < ActiveRecord::Migration[5.2]
  def up
    drop_table :custom_materials
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
