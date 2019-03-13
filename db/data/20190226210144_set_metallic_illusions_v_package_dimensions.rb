class SetMetallicIllusionsVPackageDimensions < ActiveRecord::Migration
  
  DATA = [
    { sku: 'MI601', width: '6', height: '6', depth: 36 },
    { sku: 'MI602', width: '6', height: '6', depth: 36 },
    { sku: 'MI603', width: '6', height: '6', depth: 36 },
    { sku: 'MI604', width: '6', height: '6', depth: 36 },
    { sku: 'MI605', width: '6', height: '6', depth: 36 },
    { sku: 'MI606', width: '6', height: '6', depth: 36 },
    { sku: 'MI607', width: '6', height: '6', depth: 36 },
    { sku: 'MI608', width: '6', height: '6', depth: 36 },
    { sku: 'MI609', width: '6', height: '6', depth: 36 },
    { sku: 'MI610', width: '6', height: '6', depth: 36 },
    { sku: 'MI611', width: '6', height: '6', depth: 36 },
    { sku: 'MI612', width: '6', height: '6', depth: 36 },
    { sku: 'MI613', width: '6', height: '6', depth: 36 },
    { sku: 'MI614', width: '6', height: '6', depth: 36 },
    { sku: 'MI615', width: '6', height: '6', depth: 36 },
    { sku: 'MI616', width: '6', height: '6', depth: 36 },
    { sku: 'MI617', width: '6', height: '6', depth: 36 },
    { sku: 'MI618', width: '6', height: '6', depth: 36 },
    { sku: 'MI619', width: '6', height: '6', depth: 36 },
    { sku: 'MI620', width: '6', height: '6', depth: 36 },
    { sku: 'MI621', width: '6', height: '6', depth: 36 },
    { sku: 'MI622', width: '6', height: '6', depth: 36 },
    { sku: 'MI623', width: '6', height: '6', depth: 36 },
    { sku: 'MI624', width: '6', height: '6', depth: 36 },
    { sku: 'MI625', width: '6', height: '6', depth: 36 },
    { sku: 'MI626', width: '6', height: '6', depth: 36 },
    { sku: 'MI627', width: '7', height: '13.5', depth: 56 },
    { sku: 'MI628', width: '7', height: '13.5', depth: 56 },
    { sku: 'MI629', width: '7', height: '13.5', depth: 56 },
    { sku: 'MI630', width: '7', height: '13.5', depth: 56 },
    { sku: 'MI631', width: '7', height: '13.5', depth: 56 },
    { sku: 'MI632', width: '6', height: '6', depth: 36 },
    { sku: 'MI633', width: '6', height: '6', depth: 36 },
    { sku: 'MI634', width: '6', height: '6', depth: 36 },
    { sku: 'MI635', width: '6', height: '6', depth: 36 },
    { sku: 'MI636', width: '7', height: '13.5', depth: 56 },
    { sku: 'MI637', width: '7', height: '13.5', depth: 56 },
    { sku: 'MI638', width: '7', height: '13.5', depth: 56 },
    { sku: 'MI639', width: '6', height: '6', depth: 36 },
    { sku: 'MI640', width: '7', height: '13.5', depth: 56 },
    { sku: 'MI641', width: '7', height: '13.5', depth: 56 },
    { sku: 'MI642', width: '6', height: '6', depth: 36 },
    { sku: 'MI643', width: '6', height: '6', depth: 36 },
  ]
  
  def up
    DATA.each do |item|
      v = Variant.find_by(sku: item[:sku])
      v.update_attributes({ width: item[:width], height: item[:height], depth: item[:depth]})
    end

  end

  def down
    DATA.each do |item|
      v = Variant.find_by(sku: item[:sku])
      v.update_attributes({ width: nil, height: nil, depth: nil})
    end
  end
end
