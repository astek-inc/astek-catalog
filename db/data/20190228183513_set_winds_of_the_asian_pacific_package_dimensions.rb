class SetWindsOfTheAsianPacificPackageDimensions < ActiveRecord::Migration
  def up
    Collection.find_by(name: 'Winds of the Asian Pacific').designs.each do |d|
      d.variants.each do |v|
        v.update_attributes({ width: 6, height: 6, depth: 38 })
      end
    end
  end

  def down
    Collection.find_by(name: 'Winds of the Asian Pacific').designs.each do |d|
      d.variants.each do |v|
        v.update_attributes({ width: nil, height: nil, depth: nil })
      end
    end
  end
end
