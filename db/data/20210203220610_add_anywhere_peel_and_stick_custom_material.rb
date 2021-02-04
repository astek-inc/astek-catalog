class AddAnywherePeelAndStickCustomMaterial < ActiveRecord::Migration[5.2]
  def up

    neenah = Substrate.find_by(name: 'Neenah DigiScape Stick-R')
    magik_stik = Substrate.find_by(name: 'DCM Magik-Stik')

    Design.where(user_can_select_material: true).each do |d|
      if d.custom_materials.map { |cm| cm.substrate }.include? neenah
        # puts d.sku
        d.set_custom_material magik_stik
      end
    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
