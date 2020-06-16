class UpdateSocietyOfWonderlandSubstrates < ActiveRecord::Migration[5.2]
  def up
    astek_busniess = Website.find_by(domain: 'astek.com')
    astek_home = Website.find_by(domain: 'astekhome.com')
    matte_vinyl = Substrate.find_by(name: 'Matte Vinyl')

    collection = Collection.find_by(name: 'Society of Wonderland')
    collection.designs.each do |design|
      design.variants.each do |variant|
        update = false
        variant.variant_substrates.each do |variant_substrate|
          if variant_substrate.substrate.name == 'Paper'
            variant_substrate.websites = [astek_home]
            update = true
          end
        end
        if update
          VariantSubstrate.create! variant: variant, substrate: matte_vinyl, websites: [astek_busniess]
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
