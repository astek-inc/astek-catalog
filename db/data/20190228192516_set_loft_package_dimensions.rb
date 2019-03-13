class SetLoftPackageDimensions < ActiveRecord::Migration

  COLLECTION = 'Loft'
  DIMENSIONS = %w[7 7 25]

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
