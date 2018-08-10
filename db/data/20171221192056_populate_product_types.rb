class PopulateProductTypes < ActiveRecord::Migration

  PRODUCT_TYPES = [

      # Digital
      { name: 'Featured Designers', product_category: 'Digital', description: '' },
      { name: 'Murals', product_category: 'Digital', description: '' },
      { name: 'Studio', product_category: 'Digital', description: '' },

      # Naturals
      { name: 'Cork', product_category: 'Naturals', description: '' },
      { name: 'Grasscloth', product_category: 'Naturals', description: '' },
      { name: 'Mica', product_category: 'Naturals', description: '' },
      { name: 'Silk', product_category: 'Naturals', description: '' },

      # Specialty
      { name: 'Contact Paper', product_category: 'Specialty', description: '' },
      { name: 'Exclusive Lines', product_category: 'Specialty', description: '' },
      { name: 'Metallic', product_category: 'Specialty', description: '' },
      { name: 'Residential', product_category: 'Specialty', description: '' },
      { name: 'Textured', product_category: 'Specialty', description: '' },
      { name: 'Window Film', product_category: 'Specialty', description: '' },

  ]

  def self.up
    PRODUCT_TYPES.each do |type|
      type[:product_category] = ProductCategory.find_by(name: type[:product_category])
      ProductType.create!(type)
    end
  end

  def self.down
    PRODUCT_TYPES.each do |type|
      ProductType.destroy_all
    end
  end
end
