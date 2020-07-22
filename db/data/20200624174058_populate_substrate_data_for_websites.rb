class PopulateSubstrateDataForWebsites < ActiveRecord::Migration[5.2]

  SUBSTRATES = [
      { name: 'Acoustical', description: 'Digitally printable acoustical material. 54" wide.' },
      { name: 'Acrylic', description: 'Rigid acrylic sheets available in either 4\'x8\' or 5\'x10\' sheets. 1/8", 1/4" and 1/2" thicknesses available.' },
      { name: 'Arlon High-Tack Adhesive', description: 'Adhesive-backed high tack adhesive film. Durable for wrapping unusual finishes such as brick and cinderblock. 54" wide.' },
      { name: 'Artist Canvas', description: 'Specialty canvas for fine art projects. Ideal for framing and stretching. Not suggested as wallcovering. Available in 62", 96" and 126" widths.' },
      { name: 'Backlit Film', description: 'Backlit film ideal for light boxes and POP displays. Available in 54", 60" and 85" widths.' },
      { name: 'Bali', description: 'Durable Type II commercial grade vinyl with a woven grasscloth emboss. 52" wide.' },
      { name: 'Banner', description: 'Durable banner material. Ideal for grommets or pole pockets. Available in 54", 126" and 192" widths.' },
      { name: 'Black Mylar', description: 'Durable Type II commercial grade vinyl with a black foil finish. 54" wide.' },
      { name: 'Brushed Copper Mylar', description: 'Durable Type II commercial grade vinyl with a brushed copper foil finish. 54" wide.' },
      { name: 'Brushed Silver E-Panel', description: 'Rigid PVC core sandwiched between two brushed aluminum sheets. 4\'x8\' sheets in 1/8" thickness.' },
      { name: 'Calabria', description: 'Durable Type II commercial grade vinyl with a brushed silver emboss. 54" wide.' },
      { name: 'Clear Adhesive', description: 'Adhesive-backed window film with a crystal clear finish. 48"wide.' },
      { name: 'Clear Static Cling', description: 'This printing technique, color-white-color, enables this image to be visible from both sides. 54" wide.' },
      { name: 'Eco Canvas', description: 'PVC free specialty canvas for art, signage and wallcovering. Available in 54" and 122" widths.' },
      { name: 'Fabric Adhesive', description: 'Adhesive-backed removable fabric. 60" wide.' },
      { name: 'Fiji', description: 'Durable Type II commercial grade vinyl with a stucco and plaster like emboss. 54" wide.' },
      { name: 'Gobi', description: 'Durable Type II commercial grade vinyl with a stucco and plaster like emboss. 54" wide.' },
      { name: 'Gold Canvas', description: 'Specialty gold canvas for fine art, signage, exhibits and displays. Not suggested as wallcovering. Available in 61" and 122" widths.' },
      { name: 'Gold Mylar', description: 'Durable Type II commercial grade vinyl with a gold foil finish. 54" wide.' },
      { name: 'Kalahari', description: 'Durable Type II commercial grade vinyl with a fine stipple emboss. 54" wide.' },
      { name: 'Linen', description: 'Specialty paper-backed linen. 36" wide.' },
      { name: 'Los Feliz', description: 'Durable Type II commercial grade vinyl with a fine mesh emboss. 54" wide.' },
      { name: 'Matte Vinyl', description: 'Durable Type II commercial grade vinyl with a smooth finish. 54" wide.' },
      { name: 'Monterey', description: 'Durable Type II commercial grade vinyl with a artist canvas emboss. 54" wide.' },
      { name: 'Paper', description: 'Standard wallpaper. 54" wide.' },
      { name: 'Palermo', description: 'Durable Type II commercial grade vinyl with a brushed pearl emboss. 54" wide.' },
      { name: 'Palisades', description: 'Durable Type II commercial grade vinyl with a silk emboss. 54" wide.' },
      { name: 'Pebble Textured Window Film', description: 'Adhesive-backed window film with a mottled emboss. 48"wide.' },
      { name: 'Pearl Canvas', description: 'Specialty pearl canvas for fine art, signage, exhibits and displays. Not suggested as wallcovering. Available in 61" and 122" widths.' },
      { name: 'Polyedge UV', description: 'PVC free magnetic receptive film with a matte print surface. Ideal for POP signage, walls and displays. Effortless installation for frequently changed graphics.' },
      { name: 'Smooth Topeka', description: 'Type II, eco-friendly, and PVC-free, Smooth Topeka is made with 31% post consumer recycled content. Perfect for earning LEED credits. 54" wide.' },
      { name: 'Sandstone', description: 'Durable Type II commercial grade vinyl with a light stipple emboss. 54" wide.' },
      { name: 'Sparkle', description: 'Durable Type II commercial grade vinyl with a woven emboss dusted with glitter. 54" wide.' },
      { name: 'Spectre', description: 'Durable Type II commercial grade vinyl with a fiber emboss. 54" wide.' },
      { name: 'Sierra', description: 'Durable Type II commercial grade vinyl with a wood texture emboss. 54" wide.' },
      { name: 'Silver Canvas', description: 'Specialty silver canvas for fine art, signage, exhibits and displays. Not suggested as wallcovering. Available in 61" and 122" widths.' },
      { name: 'Silver Dazzle', description: 'Durable Type II commercial grade vinyl with a silver sparkled beaded emboss. 54" wide.' },
      { name: 'Silver Gecko', description: 'Durable Type II commercial grade vinyl with a silver foil finish and beaded emboss. 54" wide.' },
      { name: 'Silver Mylar', description: 'Durable Type II commercial grade vinyl with a silver foil finish. 54" wide.' },
      { name: 'Silver Spectre', description: 'Durable Type II commercial grade vinyl with a silver foil finish and a fiber emboss. 54" wide.' },
      { name: 'Silver Weave', description: 'Durable Type II commercial grade vinyl with a silver foil finish and a woven grasscloth emboss. 54" wide.' },
      { name: 'Sonora', description: 'Durable Type II commercial grade vinyl with a raw canvas emboss. 54" wide.' },
      { name: 'Topeka', description: 'Type II, eco-friendly, and PVC-free, Smooth Topeka is made with 31% post consumer recycled content. Perfect for earning LEED credits. 54" wide.' },
      { name: 'Touch of Gold', description: 'Specialty matte gold paper. 29" wide.' },
      { name: 'White Mylar', description: 'Durable Type II commercial grade vinyl with a smooth pearlescent foil finish. 54" wide.' },
      { name: 'Vinyl Adhesive', description: 'Adhesive-backed removable vinyl. 54" wide.' },
      { name: '3M Vinyl Adhesive', description: 'Adhesive-backed permanent film. 54" wide.' }
  ]

  def up

    both_websites = Website.where(domain: %w[astek.com astekhome.com])
    astek_business_website = Website.find_by(domain: 'astek.com')

    SUBSTRATES.each do |s|
      substrate = Substrate.find_or_create_by!(name: s[:name])
      puts substrate.name
      substrate.websites = [astek_business_website]
      substrate.update_attribute('description', s[:description])
    end

    puts '- '*30

    Substrate.where(display_on_public_sites: true).each do |s|
      puts s.name
      s.websites = both_websites
    end

    # raise
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
  end
end


