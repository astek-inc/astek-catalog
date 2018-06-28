class PopulateVendors < ActiveRecord::Migration

  VENDORS = [
      {name: 'Astek Inc.', description: "In-house design and production" }
  ]

  def up
    VENDORS.each do |vendor|
      Vendor.create!(vendor)
    end
  end

  def down
    Vendors..destroy_all
  end
end
