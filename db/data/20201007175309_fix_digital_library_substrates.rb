class FixDigitalLibrarySubstrates < ActiveRecord::Migration[5.2]
  def up

    astek_business = Website.find_by(domain: 'astek.com')
    astek_home = Website.find_by(domain: 'astekhome.com')
    paper = Substrate.find_by(name: 'Paper')

    Collection.find_by(name: 'Digital Library').designs.each do |d|
      d.variants.each do |v|
        v.variant_substrates.each do |vs|
          if vs.substrate.name == 'Matte Vinyl'
            vs.websites = [astek_business]
          end
        end
        v.variant_substrates << VariantSubstrate.create!(variant: v, substrate: paper, websites: [astek_home])
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
