class PopulateSubstrateWeightsPerSquareFoot < ActiveRecord::Migration[5.2]
  def up
    Substrate.all.each do |s|

      if s.name == 'Paper'
        weight = BigDecimal(0.1, 2)
      else
        weight = BigDecimal(0.15, 2)
      end

      s.update_attribute('weight_per_square_foot', weight)

    end
  end

  def down
    Substrate.all.each do |s|
      s.update_attribute('weight_per_square_foot', nil)
    end
  end
end
