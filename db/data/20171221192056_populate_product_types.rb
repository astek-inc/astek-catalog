class PopulateProductTypes < ActiveRecord::Migration

  PRODUCT_TYPES = [

      # Digital
      { name: 'Featured Designers', product_category: 'Digital', description: '', websites: %w[astek.com astekhome.com] },
      { name: 'Murals', product_category: 'Digital', description: '', websites: %w[astek.com astekhome.com] },
      { name: 'Studio', product_category: 'Digital', description: '', websites: %w[astek.com astekhome.com] },

      # Naturals
      { name: 'Cork', product_category: 'Naturals', description: '', websites: %w[astek.com astekhome.com] },
      { name: 'Grasscloth', product_category: 'Naturals', description: '', websites: %w[astek.com astekhome.com] },
      { name: 'Mica', product_category: 'Naturals', description: '', websites: %w[astek.com astekhome.com] },
      { name: 'Silk', product_category: 'Naturals', description: '', websites: %w[astek.com astekhome.com] },

      # Specialty
      { name: 'Contact Paper', product_category: 'Specialty', description: '', websites: %w[astek.com astekhome.com] },
      { name: 'Exclusive Lines', product_category: 'Specialty', description: '', websites: %w[astekhome.com] },
      { name: 'Metallic', product_category: 'Specialty', description: '', websites: %w[astek.com astekhome.com] },
      { name: 'Residential', product_category: 'Specialty', description: '', websites: %w[astek.com] },
      { name: 'Textured', product_category: 'Specialty', description: '', websites: %w[astek.com astekhome.com] },
      { name: 'Window Film', product_category: 'Specialty', description: '', websites: %w[astek.com astekhome.com] },

  ]

  def self.up
    PRODUCT_TYPES.each do |type|
      type[:product_category] = ProductCategory.find_by(name: type[:product_category])
      type[:websites] = Website.where(domain: type[:websites])
      ProductType.create!(type)
    end
  end

  def self.down
    PRODUCT_TYPES.each do |type|
      ProductType.destroy_all
    end
  end
end
