class PopulateSubstrateCategories < ActiveRecord::Migration

  CATEGORIES = %w[
    Banner
    Canvas
    LEEDS\ Qualified
    Metallics
    Mylars
    Rolled
    Self-Adhesive
    Textured
    Type\ II
    Vinyl
  ]

  def up
    CATEGORIES.each do |cat|
      SubstrateCategory.create!(name: cat)
    end
  end

  def down
    CATEGORIES.each do |cat|
      SubstrateCategory.find_by(name: cat).destroy!
    end
  end
end
