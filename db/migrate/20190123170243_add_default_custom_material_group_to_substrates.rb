class AddDefaultCustomMaterialGroupToSubstrates < ActiveRecord::Migration
  def change
    add_column :substrates, :default_custom_material_group, :boolean
  end
end
