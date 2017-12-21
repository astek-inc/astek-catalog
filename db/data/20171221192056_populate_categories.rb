class PopulateCategories < ActiveRecord::Migration

  CATEGORIES = [
      { name: 'Astek Digital', description: 'Astek digitals are digital!', keywords: 'Wallcovering, wall, covering, digital' },
      { name: 'Naturals', description: 'Naturals are natural!', keywords: 'Wallcovering, wall, covering, natural' },
      { name: 'Specialty', description: 'Specialty wallcoverings are special!', keywords: 'Wallcovering, wall, covering, specialty' },
  ]

  def self.up
    CATEGORIES.each do |cat|
      Category.create!(cat)
    end
  end

  def self.down
    CATEGORIES.each do |cat|
      Category.find_by(name: cat[:name]).destroy!
    end
    # raise ActiveRecord::IrreversibleMigration
  end
end
