class MoveCustomMaterialSettingsFromCollectionsToDesigns < ActiveRecord::Migration
  def up
    default_substrates = Substrate.where(default_custom_material_group: true)

    Collection.where(user_can_select_material: true).each do |coll|
      puts "Collection #{coll.name}"
      coll.designs.each do |des|
        puts "Design #{des.name}"

        default_substrates.each do |s|
          des.custom_materials << CustomMaterial.create!(design: des, substrate: s, default_material: (s.name == 'Paper'))
        end
        des.user_can_select_material = true
        des.save!

      end
    end
    # raise
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
