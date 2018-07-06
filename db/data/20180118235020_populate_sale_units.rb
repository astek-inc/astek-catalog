class PopulateSaleUnits < ActiveRecord::Migration

  SALE_UNITS = [
      { name: 'Meter', description: '' },
      { name: 'Panel', description: '' },
      { name: 'Roll', description: '' },
      { name: 'Set', description: '' },
      { name: 'Sheet', description: '' },
      { name: 'Square Foot', description: '' },
      { name: 'Yard', description: '' },
  ]

  def up
    SALE_UNITS.each do |su|
      SaleUnit.create!(su)
    end
  end

  def down
    SaleUnit.destroy_all
  end
end
