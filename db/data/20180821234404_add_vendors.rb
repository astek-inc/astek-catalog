class AddVendors < ActiveRecord::Migration

  VENDORS = [
    'Anaglypta',
    'Asiana',
    'BN',
    'Capiz Shells',
    'DC Fix',
    'Omni',
    'ROTEX',
    'Tokiwa',
    'Tokyo',
    'Wallquest',
  ]

  def up
    VENDORS.each do |vendor|
      Vendor.create!(name: vendor)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
