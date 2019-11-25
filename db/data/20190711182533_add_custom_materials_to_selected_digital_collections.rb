class AddCustomMaterialsToSelectedDigitalCollections < ActiveRecord::Migration[5.2]

  COLLECTIONS = %w[Azulejos Damasks Fliepaper Kahala Marbles Natsukashii Plaids Revival]

  def up

    substrates = Substrate.where('default_custom_material_group = ?', true)

    COLLECTIONS.each do |name|
      collection = Collection.find_by(name: name)
      collection.designs.each do |d|
        d.user_can_select_material = true
        d.save!

        d.custom_materials.each do |cm|
          CustomMaterial.where(design: d).destroy_all
        end

        substrates.each do |s|
          d.custom_materials << CustomMaterial.create!(design: d, substrate: s, default_material: s.name == 'Paper')
        end
      end
    end

  end

  def down

    COLLECTIONS.each do |name|
      collection = Collection.find_by(name: name)
      collection.designs.each do |d|
        d.user_can_select_material = false
        d.save!
        d.custom_materials.each do |cm|
          CustomMaterial.where(design: d).destroy_all
        end
      end
    end

  end
end
