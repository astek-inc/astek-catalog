class PopulateVendors < ActiveRecord::Migration

  VENDORS = [
      { name: 'Astek', description: 'In-house design and production' },
      { name: 'Nina Hancock', description: '' },
      { name: 'Wallquest', description: '' },
  ]

  def up
    VENDORS.each do |vendor|
      Vendor.create!(vendor)
    end
  end

  def down
    Vendors.destroy_all
  end

end
