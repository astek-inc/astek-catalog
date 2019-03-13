class SetJellyBeansPackageDimensions < ActiveRecord::Migration

  DATA = [
      { sku: 'JB80000', width: '6', height: '6', depth: '36' },
      { sku: 'JB80001', width: '6', height: '6', depth: '36' },
      { sku: 'JB80002', width: '6', height: '6', depth: '36' },
      { sku: 'JB80101', width: '6', height: '6', depth: '36' },
      { sku: 'JB80104', width: '6', height: '6', depth: '36' },
      { sku: 'JB80201', width: '6', height: '6', depth: '36' },
      { sku: 'JB80202', width: '6', height: '6', depth: '36' },
      { sku: 'JB80204', width: '6', height: '6', depth: '36' },
      { sku: 'JB80300', width: '6', height: '6', depth: '36' },
      { sku: 'JB80301', width: '6', height: '6', depth: '36' },
      { sku: 'JB80302', width: '6', height: '6', depth: '36' },
      { sku: 'JB80400', width: '6', height: '6', depth: '36' },
      { sku: 'JB80401', width: '6', height: '6', depth: '36' },
      { sku: 'JB80402', width: '6', height: '6', depth: '36' },
      { sku: 'JB80600', width: '6', height: '6', depth: '36' },
      { sku: 'JB80601', width: '6', height: '6', depth: '36' },
      { sku: 'JB80602', width: '6', height: '6', depth: '36' },
      { sku: 'JB80700', width: '6', height: '6', depth: '36' },
      { sku: 'JB80701', width: '6', height: '6', depth: '36' },
      { sku: 'JB80702', width: '6', height: '6', depth: '36' },
      { sku: 'JB80703', width: '6', height: '6', depth: '36' },
      { sku: 'JB80800', width: '6', height: '6', depth: '36' },
      { sku: 'JB80801', width: '6', height: '6', depth: '36' },
      { sku: 'JB80802', width: '6', height: '6', depth: '36' },
      { sku: 'JB81000', width: '6', height: '6', depth: '36' },
      { sku: 'JB81001', width: '6', height: '6', depth: '36' },
      { sku: 'JB81002', width: '6', height: '6', depth: '36' },
      { sku: 'JB81003', width: '6', height: '6', depth: '36' },
      { sku: 'JB81004', width: '6', height: '6', depth: '36' },
      { sku: 'JB81005', width: '6', height: '6', depth: '36' },
      { sku: 'JB81201', width: '6', height: '6', depth: '36' },
      { sku: 'JB81202', width: '6', height: '6', depth: '36' },
      { sku: 'JB81204', width: '6', height: '6', depth: '36' },
      { sku: 'JB81301', width: '6', height: '6', depth: '36' },
      { sku: 'JB81304', width: '6', height: '6', depth: '36' },
      { sku: 'JB81306', width: '6', height: '6', depth: '36' },
      { sku: 'JB81307', width: '6', height: '6', depth: '36' },
      { sku: 'JB81314', width: '6', height: '6', depth: '36' },
      { sku: 'JB81401', width: '6', height: '6', depth: '36' },
      { sku: 'JB81402', width: '6', height: '6', depth: '36' },
      { sku: 'JB81403', width: '6', height: '6', depth: '36' },
      { sku: 'JB81604', width: '6', height: '6', depth: '36' },
      { sku: 'JB81606', width: '6', height: '6', depth: '28' },
      { sku: 'JB81607', width: '6', height: '6', depth: '28' },
      { sku: 'JB81701', width: '6', height: '6', depth: '28' },
      { sku: 'JB81702', width: '6', height: '6', depth: '28' },
      { sku: 'JB81850B', width: '6', height: '6', depth: '12' },
      { sku: 'JB81851B', width: '6', height: '6', depth: '12' },
      { sku: 'JB81901M', width: '6', height: '6', depth: '28' },
      { sku: 'JB81902M', width: '6', height: '6', depth: '28' },
      { sku: 'JB82000M', width: '6', height: '6', depth: '28' },
      { sku: 'JB82100M', width: '6', height: '6', depth: '28' },
      { sku: 'JB82600', width: '6', height: '6', depth: '28' },
      { sku: 'JB82601', width: '6', height: '6', depth: '28' },
      { sku: 'JB82602', width: '6', height: '6', depth: '28' },
      { sku: 'JB82700', width: '6', height: '6', depth: '28' },
      { sku: 'JB82701', width: '6', height: '6', depth: '28' },
      { sku: 'JB82707', width: '6', height: '6', depth: '28' },
      { sku: 'JB82708', width: '6', height: '6', depth: '28' },
      { sku: 'JB82800', width: '6', height: '6', depth: '28' },
      { sku: 'JB82801', width: '6', height: '6', depth: '28' },
      { sku: 'JB82900', width: '6', height: '6', depth: '28' },
      { sku: 'JB83001', width: '6', height: '6', depth: '28' },
      { sku: 'JB83101', width: '6', height: '6', depth: '28' },
      { sku: 'JB83102', width: '6', height: '6', depth: '28' },
      { sku: 'JB83201', width: '6', height: '6', depth: '28' },
      { sku: 'JB83202', width: '6', height: '6', depth: '28' },
      { sku: 'JB83203', width: '6', height: '6', depth: '28' },
      { sku: 'JB83301', width: '6', height: '6', depth: '28' },
      { sku: 'JB83402', width: '6', height: '6', depth: '28' },
      { sku: 'JB83502', width: '6', height: '6', depth: '28' },
      { sku: 'JB83504', width: '6', height: '6', depth: '28' },
      { sku: 'JBCR74002', width: '6', height: '6', depth: '28' },
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
