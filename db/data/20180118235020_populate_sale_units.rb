class PopulateSaleUnits < ActiveRecord::Migration
  SALE_UNITS = [
      { name: 'Roll', description: '' },
      { name: 'Square Foot', description: '' },
      { name: 'Set', description: '' },
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
