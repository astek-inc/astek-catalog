class SetVogueVelourPackageDimensions < ActiveRecord::Migration
  def up
    Collection.find_by(name: 'Vogue Velour').designs.each do |d|
      d.variants.each do |v|
        v.update_attributes({ width: 6, height: 6, depth: 36 })
      end
    end
  end

  def down
    Collection.find_by(name: 'Vogue Velour').designs.each do |d|
      d.variants.each do |v|
        v.update_attributes({ width: nil, height: nil, depth: nil })
      end
    end
  end
end
