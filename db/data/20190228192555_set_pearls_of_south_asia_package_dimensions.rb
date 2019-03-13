class SetPearlsOfSouthAsiaPackageDimensions < ActiveRecord::Migration

  COLLECTION = 'Pearls of South Asia'
  DIMENSIONS = %w[24 24 12]

  def up
    Collection.find_by(name: COLLECTION).designs.each do |d|
      d.variants.each do |v|
        v.update_attributes({ width: DIMENSIONS[0], height: DIMENSIONS[1], depth: DIMENSIONS[2] })
      end
    end
  end

  def down
    Collection.find_by(name: COLLECTION).designs.each do |d|
      d.variants.each do |v|
        v.update_attributes({ width: nil, height: nil, depth: nil })
      end
    end
  end

end
