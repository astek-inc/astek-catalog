class SetBlissPackageDimensions < ActiveRecord::Migration
  
  DATA = [
      { sku: 'BL101', width: '6', height: '6', depth: '38' },
      { sku: 'BL102', width: '6', height: '6', depth: '38' },
      { sku: 'BL103', width: '6', height: '6', depth: '38' },
      { sku: 'BL104', width: '6', height: '6', depth: '38' },
      { sku: 'BL105', width: '6', height: '6', depth: '38' },
      { sku: 'BL106', width: '6', height: '6', depth: '38' },
      { sku: 'BL107', width: '6', height: '6', depth: '38' },
      { sku: 'BL108', width: '6', height: '6', depth: '38' },
      { sku: 'BL109', width: '6', height: '6', depth: '38' },
      { sku: 'BL110', width: '6', height: '6', depth: '38' },
      { sku: 'BL111', width: '6', height: '6', depth: '38' },
      { sku: 'BL112', width: '6', height: '6', depth: '38' },
      { sku: 'BL113', width: '6', height: '6', depth: '38' },
      { sku: 'BL114', width: '6', height: '6', depth: '38' },
      { sku: 'BL115', width: '6', height: '6', depth: '38' },
      { sku: 'BL116', width: '6', height: '6', depth: '38' },
      { sku: 'BL117', width: '6', height: '6', depth: '38' },
      { sku: 'BL118', width: '6', height: '6', depth: '38' },
      { sku: 'BL119', width: '6', height: '6', depth: '38' },
      { sku: 'BL120', width: '6', height: '6', depth: '38' },
      { sku: 'BL121', width: '6', height: '6', depth: '38' },
      { sku: 'BL122', width: '6', height: '6', depth: '38' },
      { sku: 'BL123', width: '6', height: '6', depth: '38' },
      { sku: 'BL124', width: '6', height: '6', depth: '38' },
      { sku: 'BL125', width: '6', height: '6', depth: '38' },
      { sku: 'BL126', width: '6', height: '6', depth: '38' },
      { sku: 'BL127', width: '6', height: '6', depth: '36' },
      { sku: 'BL128', width: '6', height: '6', depth: '36' },
      { sku: 'BL129', width: '6', height: '6', depth: '36' },
      { sku: 'BL130', width: '6', height: '6', depth: '36' },
      { sku: 'BL131', width: '6', height: '6', depth: '36' },
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
