class SetDcFixPackageDimensions < ActiveRecord::Migration

  def up
    designs.each do |d|
      d.variants.each do |v|
        v.update_attributes({ width: 6, height: 6, depth: 36 })
      end
    end
  end

  def down
    designs.each do |d|
      d.variants.each do |v|
        v.update_attributes({ width: nil, height: nil, depth: nil })
      end
    end
  end

  def designs
    Design.where(vendor: Vendor.find_by(name: 'd-c-fix'))
  end

end
