class SetDigitalsPackageDimensions < ActiveRecord::Migration
  def up
    Collection.where('product_category_id = ?', ProductCategory.find_by(name: 'Digital').id).where.not(name: %w[Digital Library Pre-1920s 1920s-1930s 1940s-1950s 1960s-1970s]).each do |c|
      c.designs.each do |d|
        d.variants.each do |v|
          v.update_attributes({ width: 7, height: 7, depth: 54 })
        end
      end
    end

    # raise
  end

  def down
    Collection.where('product_category_id = ?', ProductCategory.find_by(name: 'Digital').id).where.not(name: %w[Digital Library Pre-1920s 1920s-1930s 1940s-1950s 1960s-1970s]).each do |c|
      c.designs.each do |d|
        d.variants.each do |v|
          v.update_attributes({ width: nil, height: nil, depth: nil })
        end
      end
    end
  end
end
