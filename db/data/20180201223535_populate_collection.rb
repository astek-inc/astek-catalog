class PopulateCollection < ActiveRecord::Migration

  # IMAGE_URLS = %w[
  #   http://www.astekwallcovering.com/sites/default/files/micrographia_slides1.jpg
  #   http://www.astekwallcovering.com/sites/default/files/micrographia_slides2.jpg
  #   http://www.astekwallcovering.com/sites/default/files/micrographia_slides3.jpg
  #   http://www.astekwallcovering.com/sites/default/files/micrographia_slides4.jpg
  # ]

  def up

    product_type = ProductType.find_by(name: 'Murals')
    vendor = Vendor.find_by(name: 'Astek Inc.')

    collection = Collection.create({
      product_type: product_type,
      name: 'Micrographia',
      description: 'Inspired by life under a microscope, Micrographia offers a new and beautiful perspective on what you thought was familiar. Through creativity, abstraction, and material exploration, Astek\'s in-house design team used far ranging media such as paint, collage, sculpture, print-making, and photography to bring their ideas to life.',
      keywords: 'mural, abstract, metallic, artistic, painterly, sci-fi, science',
      vendor: vendor
    })

    # IMAGE_URLS.each do |url|
    #   CollectionImage.create!({
    #     remote_file_url: url,
    #     type: 'CollectionImage',
    #     owner_id: collection.id
    #   })
    # end

  end

  def down

    Collection.find_by(name: 'Micrographia').destroy!

  end
end
