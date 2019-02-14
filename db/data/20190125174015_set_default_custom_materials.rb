class SetDefaultCustomMaterials < ActiveRecord::Migration

  MATERIALS = [
      { name: 'Paper', surcharge: '0' },
      { name: 'White Mylar', display_name: 'Type II Commercial Vinyl', surcharge: '0.50' },
      { name: 'Wall Hug', display_name: 'Peel & Stick Wall Tiles', surcharge: '1.50' },
      { name: 'Gold Mylar', surcharge: '1.00' },
      { name: 'Silver Mylar', surcharge: '1.00' },
  ]

  def up
    MATERIALS.each do |m|
      s = Substrate.find_or_create_by(name: m[:name])
      puts s.name
      if m[:display_name]
        s.display_name = m[:display_name]
      end
      s.default_custom_material_group = true
      s.custom_material_surcharge = BigDecimal(m[:surcharge], 2)
      s.save!
    end
    # raise
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
