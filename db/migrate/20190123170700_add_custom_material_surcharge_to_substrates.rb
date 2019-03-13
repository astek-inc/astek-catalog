class AddCustomMaterialSurchargeToSubstrates < ActiveRecord::Migration
  def change
    add_column :substrates, :custom_material_surcharge, :decimal, precision: 8, scale: 2
  end
end
