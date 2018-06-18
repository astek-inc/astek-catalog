class PopulateVariants < ActiveRecord::Migration

  DATA = [
      {
          design: 'Lumen',
          variants:[
            {name: 'Lumen - Ash', sku: 'AD367-1', price_code: 'ABC-1', image_url: 'https://s3.us-west-2.amazonaws.com/astek-product-images/Lumen_Ash_web.jpg', colors: ['Red', 'Black and White']},
            {name: 'Lumen - Nova', sku: 'AD367-2', price_code: 'ABC-1', image_url: 'https://s3.us-west-2.amazonaws.com/astek-product-images/Lumen_Nova_web.jpg', colors: ['Green', 'Black and White']},
            {name: 'Lumen - Quasar', sku: 'AD367-3', price_code: 'ABC-1', image_url: 'https://s3.us-west-2.amazonaws.com/astek-product-images/Lumen_Quasar_web.jpg', colors: ['Indigo', 'Black and White']},
          ]
      },
      {
          design: 'Apparition',
          variants:[
              {name: 'Apparition - Ethereal', sku: 'AD365-2', price_code: 'ABC-1', image_url: 'http://astek.s3.amazonaws.com/styles/extra-large/s3/Apparition_Ethereal2.jpg', colors: ['Orange', 'Black and White']},
              {name: 'Apparition - Figment', sku: 'AD365-3', price_code: 'ABC-1', image_url: 'http://astek.s3.amazonaws.com/styles/extra-large/s3/Apparition_Figment2.jpg', colors: ['Blue', 'Black and White']},
              {name: 'Apparition - Cumulus', sku: 'AD365-1', price_code: 'ABC-1', image_url: 'http://www.astekwallcovering.com/sites/default/files/styles/extra-large/public/designs/Apparition_Cumulus2.jpg', colors: ['Indigo', 'Black and White']},
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
          sku: v[:sku],
          price_code: v[:price_code]
        })

        variant_image = VariantImage.create!({
          remote_file_url: v[:image_url],
          type: 'VariantImage',
          owner_id: variant.id
        })

        variant.colors << Color.where(name: v[:colors])

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
