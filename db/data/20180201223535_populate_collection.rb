class PopulateCollection < ActiveRecord::Migration
  def up

    category = Category.find_by(name: 'Digital Collections')
    websites = Website.where(domain: %w[designyourwall.com astekwallcovering.com])
    variant_data = [
        {name: 'Lumen - Ash', sku: 'AD367-1', price_code: 'ABC-1', image_url: 'https://s3.us-west-2.amazonaws.com/astek-product-images/Lumen_Ash_web.jpg'},
        {name: 'Lumen - Nova', sku: 'AD367-2', price_code: 'ABC-1', image_url: 'https://s3.us-west-2.amazonaws.com/astek-product-images/Lumen_Nova_web.jpg'},
        {name: 'Lumen - Quasar', sku: 'AD367-3', price_code: 'ABC-1', image_url: 'https://s3.us-west-2.amazonaws.com/astek-product-images/Lumen_Quasar_web.jpg'}
    ]

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

    variant_data.each do |data|
      variant = Variant.create!({
           design: design,
           variant_type: 'color_way',
           name: data[:name],
           sku: data[:sku],
           price_code: data[:price_code]
       })

      variant_image = VariantImage.new({
           remote_file_url: data[:image_url],
           type: 'VariantImage',
           owner_id: variant.id
       })

      variant_image.save!
    end


  end

  def down
    Collection.find_by(name: 'Micrographia').destroy!
    # raise ActiveRecord::IrreversibleMigration
  end
end
