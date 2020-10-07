class FixVintageSubstrates < ActiveRecord::Migration[5.2]
  def up

    astek_business = Website.find_by(domain: 'astek.com')
    astek_home = Website.find_by(domain: 'astekhome.com')
    on_air_design = Website.find_by(domain: 'onairdesign.com')

    paper = Substrate.find_by(name: 'Paper')
    matte_vinyl = Substrate.find_by(name: 'Matte Vinyl')

    Collection.where(name: %w[Pre-1920s 1920s-1930s 1940s-1950s 1960s-1970s]).each do |c|
      c.designs.each do |d|
        d.variants.each do |v|
          v.variant_substrates.each do |vs|
            if vs.substrate.name == 'Paper'
              vs.websites = [astek_home]
            end
          end
          v.variant_substrates << VariantSubstrate.create!(variant: v, substrate: matte_vinyl, websites: [astek_business, on_air_design])
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
