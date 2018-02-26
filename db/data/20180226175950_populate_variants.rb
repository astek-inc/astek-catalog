class PopulateVariants < ActiveRecord::Migration

  VARIANT_DATA = [
    {name: 'Lumen - Ash', sku: 'AD367-1', price_code: 'ABC-1', image_url: 'https://s3.us-west-2.amazonaws.com/astek-product-images/Lumen_Ash_web.jpg'},
    {name: 'Lumen - Nova', sku: 'AD367-2', price_code: 'ABC-1', image_url: 'https://s3.us-west-2.amazonaws.com/astek-product-images/Lumen_Nova_web.jpg'},
    {name: 'Lumen - Quasar', sku: 'AD367-3', price_code: 'ABC-1', image_url: 'https://s3.us-west-2.amazonaws.com/astek-product-images/Lumen_Quasar_web.jpg'}
  ]

  def up

    design = Design.find_by(name: 'Lumen')
    variant_type = VariantType.find_by(name: 'Color Way')

    VARIANT_DATA.each do |item|
      variant = Variant.create!({
        design: design,
        variant_type: variant_type,
        name: item[:name],
        sku: item[:sku],
        price_code: item[:price_code]
      })

      variant_image = VariantImage.create!({
        remote_file_url: item[:image_url],
        type: 'VariantImage',
        owner_id: variant.id
      })
    end

  end

  def down

    VARIANT_DATA.each do |item|
      Variant.find_by(name: item[:name]).destroy!
    end

  end
end
