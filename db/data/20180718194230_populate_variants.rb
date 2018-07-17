class PopulateVariants < ActiveRecord::Migration

  DATA = [
      {
          design: 'Lumen',
          variants:[
            {
                name: 'Lumen - Ash', sku: 'AD367-1',
                image_urls: ['https://s3.us-west-2.amazonaws.com/astek-product-images/Lumen_Ash_web.jpg',
                             'https://s3-us-west-2.amazonaws.com/astek-catalog-tmp/Lumen_Ash_2.jpg'],
                colors: ['Red', 'Black and White'],
                materials: ['Silver Spectre']
            },
            {
                name: 'Lumen - Nova', sku: 'AD367-2',
                image_urls: ['https://s3.us-west-2.amazonaws.com/astek-product-images/Lumen_Nova_web.jpg'],
                colors: ['Green', 'Black and White'],
                materials: ['Silver Spectre']
            },
            {
                name: 'Lumen - Quasar',
                sku: 'AD367-3',
                image_urls: ['https://s3.us-west-2.amazonaws.com/astek-product-images/Lumen_Quasar_web.jpg'],
                colors: ['Indigo', 'Black and White'],
                materials: ['Silver Spectre']
            },
          ]
      },
      {
          design: 'Apparition',
          variants:[
              {
                  name: 'Apparition - Ethereal', sku: 'AD365-2',
                  image_urls: ['http://astek.s3.amazonaws.com/styles/extra-large/s3/Apparition_Ethereal2.jpg'],
                  colors: ['Orange', 'Black and White'],
                  materials: ['White Mylar']
              },
              {
                  name: 'Apparition - Figment', sku: 'AD365-3',
                  image_urls: ['http://astek.s3.amazonaws.com/styles/extra-large/s3/Apparition_Figment2.jpg'],
                  colors: ['Blue', 'Black and White'],
                  materials: ['White Mylar']
              },
              {
                  name: 'Apparition - Cumulus', sku: 'AD365-1',
                  image_urls: ['http://www.astekwallcovering.com/sites/default/files/styles/extra-large/public/designs/Apparition_Cumulus2.jpg'],
                  colors: ['Indigo', 'Black and White'],
                  materials: ['White Mylar']
              },
          ]
      },
      {
        design: 'Xylem',
        variants:[
            {
                name: 'Xylem - Chloroplast', sku: 'AD372-1',
                image_urls: ['https://s3.amazonaws.com/dywimages/spree/images/68141/original/open-uri20171023-5-1e6ecr6.'],
                colors: ['Orange', 'Blue'],
                materials: ['Spectre']
            },
            {
                name: 'Xylem - Sultana', sku: 'AD372-2',
                image_urls: ['https://s3.amazonaws.com/dywimages/spree/images/68142/original/open-uri20171023-5-izj1ro.'],
                colors: ['Blue', 'Black and White'],
                materials: ['Spectre']
            },
            {
                name: 'Xylem - Volcanic', sku: 'AD372-3',
                image_urls: ['https://s3.amazonaws.com/dywimages/spree/images/68143/original/open-uri20171023-5-se2bo6.'],
                colors: ['Red', 'Indigo'],
                materials: ['Spectre']
            },
        ]
    }
  ]

  def up
    variant_type = VariantType.find_by(name: 'Color Way')

    DATA.each do |item|
      design = Design.find_by(name: item[:design])
      item[:variants].each do |v|

        variant = Variant.create!({
          design: design,
          variant_type: variant_type,
          name: v[:name],
          sku: v[:sku]
        })

        v[:image_urls].each do |url|
          VariantImage.create!({
            remote_file_url: url,
            type: 'VariantImage',
            owner_id: variant.id
          })
        end

        variant.colors << Color.where(name: v[:colors])
        variant.substrates << Substrate.where(name: v[:materials])

      end
    end
  end

  def down
    DATA.each do |item|
      design = Design.find_by(name: item[:design])
      design.variants.each do |v|
        puts v
        v.destroy!
      end
    end
  end
  
end
