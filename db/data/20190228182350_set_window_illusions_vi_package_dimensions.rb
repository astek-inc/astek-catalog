class SetWindowIllusionsViPackageDimensions < ActiveRecord::Migration

  DATA = [
      { sku: 'ASK701', width: '6', height: '6', depth: '45' },
      { sku: 'ASK702', width: '6', height: '6', depth: '45' },
      { sku: 'ASK703', width: '6', height: '6', depth: '45' },
      { sku: 'ASK704', width: '6', height: '6', depth: '45' },
      { sku: 'ASK705', width: '6', height: '6', depth: '45' },
      { sku: 'ASK706', width: '6', height: '6', depth: '45' },
      { sku: 'ASK707', width: '6', height: '6', depth: '45' },
      { sku: 'ASK708', width: '6', height: '6', depth: '45' },
      { sku: 'ASK709', width: '6', height: '6', depth: '45' },
      { sku: 'ASK710', width: '6', height: '6', depth: '52' },
      { sku: 'ASK711', width: '6', height: '6', depth: '52' },
      { sku: 'ASK712', width: '6', height: '6', depth: '36' },
      { sku: 'ASK713', width: '6', height: '6', depth: '52' },
      { sku: 'ASK714', width: '6', height: '6', depth: '52' },
      { sku: 'ASK715', width: '6', height: '6', depth: '52' },
      { sku: 'ASK716', width: '6', height: '6', depth: '52' },
      { sku: 'ASK717', width: '6', height: '6', depth: '52' },
      { sku: 'ASK718', width: '6', height: '6', depth: '52' },
      { sku: 'ASK719', width: '6', height: '6', depth: '45' },
      { sku: 'ASK720', width: '6', height: '6', depth: '36' },
      { sku: 'ASK721', width: '6', height: '6', depth: '52' },
      { sku: 'ASK722', width: '6', height: '6', depth: '52' },
      { sku: 'ASK723', width: '6', height: '6', depth: '52' },
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
