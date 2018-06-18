class PopulateCategories < ActiveRecord::Migration

  CATEGORIES = [
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
    CATEGORIES.each do |cat|
      websites = cat.delete(:websites)
      category = Category.create!(cat)
      websites.each do |w|
        category.websites << Website.find_by(domain: w)
      end
    end
  end

  def self.down
    CATEGORIES.each do |cat|
      Category.find_by(name: cat[:name]).destroy!
    end
  end
end
