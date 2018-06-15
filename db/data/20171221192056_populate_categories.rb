class PopulateCategories < ActiveRecord::Migration

  CATEGORIES = [
      { name: 'Contact Paper', description: '', keywords: '', sites: ['designyourwall.com'] },
      { name: 'Decals', description: '', keywords: '', sites: ['designyourwall.com'] },
      { name: 'Designers', description: '', keywords: '', sites: ['designyourwall.com'] },
      { name: 'Digital Collections', description: '', keywords: '', sites: ['astekwallcovering.com', 'designyourwall.com'] },
      { name: 'Naturals', description: '', keywords: '', sites: ['astekwallcovering.com', 'designyourwall.com'] },
      { name: 'Residential', description: '', keywords: '', sites: ['astekwallcovering.com', 'designyourwall.com'] },
      { name: 'Specialty', description: '', keywords: '', sites: ['astekwallcovering.com', 'designyourwall.com'] },
      { name: 'Window Film', description: '', keywords: '', sites: ['designyourwall.com'] }
  ]

  def self.up
    CATEGORIES.each do |cat|
      sites = cat.delete(:sites)
      category = Category.create!(cat)
      sites.each do |w|
        category.sites << Site.find_by(domain: w)
      end
    end
  end

  def self.down
    CATEGORIES.each do |cat|
      Category.find_by(name: cat[:name]).destroy!
    end
  end
end
