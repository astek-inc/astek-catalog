class CreateCustomMaterials < ActiveRecord::Migration
  def change
    create_table :custom_materials do |t|
      t.integer :design_id
      t.integer :substrate_id
      t.boolean :default_material
    end
    add_index :custom_materials, [:design_id, :substrate_id]
    add_index :custom_materials, [:substrate_id, :design_id]
  end
end

# Custom materials should really be associated with Colorways (variants),
# but the website only displays material options by design
