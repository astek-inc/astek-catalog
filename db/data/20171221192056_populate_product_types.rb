class PopulateProductTypes < ActiveRecord::Migration

  PRODUCT_TYPES = [
      { name: 'Contact Paper', description: '', keywords: '', websites: ['astekhome.com'] },
      { name: 'Decals', description: '', keywords: '', websites: ['astekhome.com'] },
      { name: 'Designers', description: '', keywords: '', websites: ['astekhome.com'] },
      { name: 'Digital Collections', description: '', keywords: '', websites: ['astek.com', 'astekhome.com'] },
      { name: 'Naturals', description: '', keywords: '', websites: ['astek.com', 'astekhome.com'] },
      { name: 'Residential', description: '', keywords: '', websites: ['astek.com', 'astekhome.com'] },
      { name: 'Specialty', description: '', keywords: '', websites: ['astek.com', 'astekhome.com'] },
      { name: 'Window Film', description: '', keywords: '', websites: ['astekhome.com'] }
  ]

  def self.up
    PRODUCT_TYPES.each do |cat|
      websites = cat.delete(:websites)
      product_type = ProductType.create!(cat)
      websites.each do |w|
        product_type.websites << Website.find_by(domain: w)
      end
    end
  end

  def self.down
    PRODUCT_TYPES.each do |cat|
      ProductType.find_by(name: cat[:name]).destroy!
    end
  end
end
