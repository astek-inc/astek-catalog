class UpdatePeelAndStickWeights < ActiveRecord::Migration[5.2]
  def up
    Collection.find(290).designs.each do |d|
      d.variants.each do |v|
        v.stock_items.each do |i|
          if i.weight < 4
            i.weight = BigDecimal('4', 0)
            i.save!
          end
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
