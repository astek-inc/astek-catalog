class UpdatePrintedNaturalsSaleInfo < ActiveRecord::Migration[5.2]
  def up
    square_foot = SaleUnit.find_by(name: 'Square Foot')
    Collection.find_by(name: 'Printed Naturals').designs.each do |d|
      d.sale_unit = square_foot
      d.price = BigDecimal('7.50')
      d.minimum_quantity = 30
      d.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
