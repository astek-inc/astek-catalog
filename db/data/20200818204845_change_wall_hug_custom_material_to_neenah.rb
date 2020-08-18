class ChangeWallHugCustomMaterialToNeenah < ActiveRecord::Migration[5.2]
  def up
    wall_hug = Substrate.find_by(name: 'Wall Hug')
    neenah = Substrate.find_by(name: 'Neenah DigiScape Stick-R')

    Design.where(user_can_select_material: true).each do |d|
      if cm = CustomMaterial.find_by(design: d, substrate: wall_hug)
        d.delete_custom_material(wall_hug)
        d.set_custom_material(neenah)
      end
    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
