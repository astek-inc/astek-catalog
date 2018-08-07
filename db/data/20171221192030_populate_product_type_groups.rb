class PopulateProductTypeGroups < ActiveRecord::Migration

  PRODUCT_TYPE_GROUPS = [
      { name: 'Digital', description: '' },
      { name: 'Naturals', description: '' },
      { name: 'Specialty', description: '' },
  ]

  def up
    PRODUCT_TYPE_GROUPS.each do |group|
      ProductTypeGroup.create!(group)
    end
  end

  def down
    PRODUCT_TYPE_GROUPS.each do |group|
      ProductTypeGroup.find_by(name: group[:name]).destroy!
    end
  end

end
