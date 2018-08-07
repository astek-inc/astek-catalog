class PopulateProductTypes < ActiveRecord::Migration

  PRODUCT_TYPES = [

      # Digital
      { name: 'Featured Designers', product_type_group: 'Digital', description: '' },
      { name: 'Murals', product_type_group: 'Digital', description: '' },
      { name: 'Studio', product_type_group: 'Digital', description: '' },

      # Naturals
      { name: 'Cork', product_type_group: 'Naturals', description: '' },
      { name: 'Grasscloth', product_type_group: 'Naturals', description: '' },
      { name: 'Mica', product_type_group: 'Naturals', description: '' },

      # Specialty
      { name: 'Contact Paper', product_type_group: 'Specialty', description: '' },
      { name: 'Exclusive Lines', product_type_group: 'Specialty', description: '' },
      { name: 'Metallic', product_type_group: 'Specialty', description: '' },
      { name: 'Residential', product_type_group: 'Specialty', description: '' },
      { name: 'Textured', product_type_group: 'Specialty', description: '' },
      { name: 'Window Film', product_type_group: 'Specialty', description: '' },

  ]

  def self.up
    PRODUCT_TYPES.each do |type|
      type[:product_type_group] = ProductTypeGroup.find_by(name: type[:product_type_group])
      ProductType.create!(type)
    end
  end

  def self.down
    PRODUCT_TYPES.each do |type|
      ProductType.destroy_all
    end
  end
end
