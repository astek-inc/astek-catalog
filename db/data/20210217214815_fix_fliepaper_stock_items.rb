class FixFliepaperStockItems < ActiveRecord::Migration[5.2]

  DATA = [
    { sku: 'FP128-1', substrate: 'Silver Mylar' },
    { sku: 'FP129-1', substrate: 'Sonora' },
    { sku: 'FP100-1', substrate: 'Silver Mylar' },
    { sku: 'FP100-2', substrate: 'Silver Mylar' },
    { sku: 'FP100-3', substrate: 'Silver Mylar' },
    { sku: 'FP186-1', substrate: 'Matte Vinyl' },
    { sku: 'FP115-1', substrate: 'Matte Vinyl' },
    { sku: 'FP176-1', substrate: 'Matte Vinyl' },
    { sku: 'FP101-1', substrate: 'Matte Vinyl' },
    { sku: 'FP101-2', substrate: 'Matte Vinyl' },
    { sku: 'FP101-3', substrate: 'Matte Vinyl' },
    { sku: 'FP149-1', substrate: 'Matte Vinyl' },
    { sku: 'FP102-1', substrate: 'Matte Vinyl' },
    { sku: 'FP124-1', substrate: 'Sonora' },
    { sku: 'FP117-1', substrate: 'Silver Mylar' },
    { sku: 'FP103-1', substrate: 'Matte Vinyl' },
    { sku: 'FP104-1', substrate: 'Matte Vinyl' },
    { sku: 'FP104-2', substrate: 'Matte Vinyl' },
    { sku: 'FP147-1', substrate: 'Matte Vinyl' },
    { sku: 'FP188-1', substrate: 'Matte Vinyl' },
    { sku: 'FP106-1', substrate: 'Matte Vinyl' },
    { sku: 'FP105-1', substrate: 'Matte Vinyl' },
    { sku: 'FP177-1', substrate: 'Matte Vinyl' },
    { sku: 'FP114-1', substrate: 'Matte Vinyl' },
    { sku: 'FP153-1', substrate: 'Matte Vinyl' },
    { sku: 'FP116-1', substrate: 'Matte Vinyl' },
    { sku: 'FP121-1', substrate: 'Silver Mylar' },
    { sku: 'FP107-1', substrate: 'Matte Vinyl' },
    { sku: 'FP175-1', substrate: 'Matte Vinyl' },
    { sku: 'FP123-1', substrate: 'Matte Vinyl' },
    { sku: 'FP151-1', substrate: 'Matte Vinyl' },
    { sku: 'FP125-1', substrate: 'Matte Vinyl' },
    { sku: 'FP178-1', substrate: 'Matte Vinyl' },
    { sku: 'FP127-1', substrate: 'Matte Vinyl' },
    { sku: 'FP182-1', substrate: 'Matte Vinyl' },
    { sku: 'FP112-1', substrate: 'Matte Vinyl' },
    { sku: 'FP179-1', substrate: 'Matte Vinyl' },
    { sku: 'FP184-1', substrate: 'Matte Vinyl' },
    { sku: 'FP146-1', substrate: 'Silver Mylar' },
    { sku: 'FP183-1', substrate: 'Matte Vinyl' },
    { sku: 'FP108-1', substrate: 'Matte Vinyl' },
    { sku: 'FP150-1', substrate: 'Sonora' },
    { sku: 'FP109-2', substrate: 'Matte Vinyl' },
    { sku: 'FP109-3', substrate: 'Matte Vinyl' },
    { sku: 'FP118-1', substrate: 'Matte Vinyl' },
    { sku: 'FP118-2', substrate: 'Matte Vinyl' },
    { sku: 'FP152-1', substrate: 'Matte Vinyl' },
    { sku: 'FP122-1', substrate: 'Matte Vinyl' },
    { sku: 'FP148-1', substrate: 'Matte Vinyl' },
    { sku: 'FP187-1', substrate: 'Matte Vinyl' },
    { sku: 'FP180-1', substrate: 'Matte Vinyl' },
    { sku: 'FP120-1', substrate: 'Matte Vinyl' },
    { sku: 'FP185-1', substrate: 'Matte Vinyl' },
    { sku: 'FP130-1', substrate: 'Matte Vinyl' },
    { sku: 'FP113-1', substrate: 'Matte Vinyl' },
    { sku: 'FP131-1', substrate: 'Matte Vinyl' },
    { sku: 'FP110-1', substrate: 'Matte Vinyl' },
    { sku: 'FP132-1', substrate: 'Matte Vinyl' },
    { sku: 'FP133-1', substrate: 'Sonora' },
    { sku: 'FP126-1', substrate: 'White Mylar' },
    { sku: 'FP111-1', substrate: 'Silver Mylar' },
    { sku: 'FP181-1', substrate: 'Matte Vinyl' },
    { sku: 'FP119-1', substrate: 'Matte Vinyl' },
    { sku: 'FP119-2', substrate: 'Matte Vinyl' }
  ]

  def up

    astek_business = Website.find_by(domain: 'astek.com')
    astek_home = Website.find_by(domain: 'astekhome.com')

    DATA.each do |item|
      
      v = Variant.find_by(sku: item[:sku])

      v.stock_items.each do |si|
        if si.substrate.name == item[:substrate]

          si.websites = [astek_business]

        else

          si.websites = [astek_home]

          case si.substrate.name
          when 'Paper'
            si.update row_order_position: :first
          when 'DCM Magik-Stik'
            si.update row_order_position: :last
          when 'Neenah DigiScape Stick-R'
            si.update row_order_position: :last
          end

        end
      end

      v.stock_items.each do |si|
        if si.websites.include? astek_business
          si.update row_order_position: :last
        end
      end

    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
