class PopulateCategories < ActiveRecord::Migration

  CATEGORIES = [
      { name: 'Contact Paper', description: '', keywords: '', clients: ['designyourwall.com'] },
      { name: 'Decals', description: '', keywords: '', clients: ['designyourwall.com'] },
      { name: 'Designers', description: '', keywords: '', clients: ['designyourwall.com'] },
      { name: 'Digital Collections', description: '', keywords: '', clients: ['astekwallcovering.com', 'designyourwall.com'] },
      { name: 'Naturals', description: '', keywords: '', clients: ['astekwallcovering.com', 'designyourwall.com'] },
      { name: 'Residential', description: '', keywords: '', clients: ['astekwallcovering.com', 'designyourwall.com'] },
      { name: 'Specialty', description: '', keywords: '', clients: ['astekwallcovering.com', 'designyourwall.com'] },
      { name: 'Window Film', description: '', keywords: '', clients: ['designyourwall.com'] }
  ]

  def self.up
    CATEGORIES.each do |cat|
      clients = cat.delete(:clients)
      category = Category.create!(cat)
      clients.each do |w|
        category.clients << Client.find_by(domain: w)
      end
    end
  end

  def self.down
    CATEGORIES.each do |cat|
      Category.find_by(name: cat[:name]).destroy!
    end
  end
end
