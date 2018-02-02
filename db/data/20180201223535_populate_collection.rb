class PopulateCollection < ActiveRecord::Migration
  def up
    require 'pp'

    category = Category.find_by(name: 'Digital Collections')
    websites = Website.where(domain: ['designyourwall.com', 'astekwallcovering.com'])

    collection = Collection.create({
      category: category,
      name: 'Micrographia',
      description: 'Inspired by life under a microscope, Micrographia offers a new and beautiful perspective on what you thought was familiar. Through creativity, abstraction, and material exploration, Astek\'s in-house design team used far ranging media such as paint, collage, sculpture, print-making, and photography to bring their ideas to life.',
      keywords: 'mural, abstract, metallic, artistic, painterly, sci-fi, science',
      websites: websites
    })

    design = Design.create({
      collection: collection,
      name: 'Lumen',
      description: 'Our printers use a digital process which is eco-friendly, allows for a wide range of printing effects, low print minimums, fast turnarounds and detailed control over output and quality.',
      keywords: 'super, awesome, amazing, fantastic, incredible',
      available_on: Time.now
    })

    variant = Variant.create({
      design: design,
      variant_type: 'color_way',
      name: 'Lumen - Ash',
      sku: 'AD367-1',
      price_code: 'ABC-1'
    })

    # raise

  end

  def down
    Collection.find_by(name: 'Micrographia').destroy!
    # raise ActiveRecord::IrreversibleMigration
  end
end
