class PopulateVendors < ActiveRecord::Migration

  VENDORS = [
      { name: 'Anaglypta', description: '' },
      { name: 'Asiana', description: '' },
      { name: 'Astek', description: 'In-house design and production' },
      { name: 'BN', description: '' },
      { name: 'Capiz Shells', description: '' },
      { name: 'DC Fix', description: '' },
      { name: 'Desima', description: '' },
      { name: 'Marburg', description: '' },
      { name: 'Nina Hancock', description: '' },
      { name: 'Omni', description: '' },
      { name: 'P&W', description: '' },
      { name: 'Rotex', description: '' },
      { name: 'Tokiwa', description: '' },
      { name: 'Tokyo', description: '' },
      { name: 'Wallquest', description: '' },
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
