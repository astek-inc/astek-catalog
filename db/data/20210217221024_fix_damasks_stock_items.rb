class FixDamasksStockItems < ActiveRecord::Migration[5.2]

  DATA = [
    { sku: 'AD396-1', substrate: 'Matte Vinyl' },
    { sku: 'AD396-2', substrate: 'Matte Vinyl' },
    { sku: 'AD396-3', substrate: 'Matte Vinyl' },
    { sku: 'AD397-1', substrate: 'Matte Vinyl' },
    { sku: 'AD397-2', substrate: 'Matte Vinyl' },
    { sku: 'AD397-3', substrate: 'Matte Vinyl' },
    { sku: 'AD398-1', substrate: 'Matte Vinyl' },
    { sku: 'AD398-2', substrate: 'Matte Vinyl' },
    { sku: 'AD398-3', substrate: 'Matte Vinyl' },
    { sku: 'AD399-1', substrate: 'Matte Vinyl' },
    { sku: 'AD399-2', substrate: 'Matte Vinyl' },
    { sku: 'AD399-3', substrate: 'Matte Vinyl' },
    { sku: 'AD400-1', substrate: 'Matte Vinyl' },
    { sku: 'AD400-2', substrate: 'Matte Vinyl' },
    { sku: 'AD400-3', substrate: 'Matte Vinyl' },
    { sku: 'AD401-1', substrate: 'Matte Vinyl' },
    { sku: 'AD401-2', substrate: 'Matte Vinyl' },
    { sku: 'AD401-3', substrate: 'Matte Vinyl' },
    { sku: 'AD402-1', substrate: 'Matte Vinyl' },
    { sku: 'AD402-2', substrate: 'Matte Vinyl' },
    { sku: 'AD402-3', substrate: 'Matte Vinyl' },
    { sku: 'AD403-1', substrate: 'Matte Vinyl' },
    { sku: 'AD403-2', substrate: 'Matte Vinyl' },
    { sku: 'AD403-3', substrate: 'Matte Vinyl' },
    { sku: 'AD404-1', substrate: 'Matte Vinyl' },
    { sku: 'AD404-2', substrate: 'Matte Vinyl' },
    { sku: 'AD404-3', substrate: 'Matte Vinyl' },
    { sku: 'AD405-1', substrate: 'Matte Vinyl' },
    { sku: 'AD405-2', substrate: 'Matte Vinyl' },
    { sku: 'AD405-3', substrate: 'Matte Vinyl' },
    { sku: 'AD457-1', substrate: 'Matte Vinyl' },
    { sku: 'AD457-2', substrate: 'Matte Vinyl' },
    { sku: 'AD457-3', substrate: 'Matte Vinyl' },
    { sku: 'AD458-1', substrate: 'Matte Vinyl' },
    { sku: 'AD458-2', substrate: 'Matte Vinyl' },
    { sku: 'AD458-3', substrate: 'Matte Vinyl' },
    { sku: 'AD459-1', substrate: 'Matte Vinyl' },
    { sku: 'AD459-2', substrate: 'Matte Vinyl' },
    { sku: 'AD459-3', substrate: 'Matte Vinyl' },
    { sku: 'AD460-1', substrate: 'Matte Vinyl' },
    { sku: 'AD460-2', substrate: 'Matte Vinyl' },
    { sku: 'AD460-3', substrate: 'Matte Vinyl' },
    { sku: 'AD461-1', substrate: 'matte Vinyl' },
    { sku: 'AD461-2', substrate: 'Matte Vinyl' },
    { sku: 'AD461-3', substrate: 'Matte Vinyl' },
    { sku: 'AD462-1', substrate: 'Matte Vinyl' },
    { sku: 'AD462-2', substrate: 'Matte Vinyl' },
    { sku: 'AD462-3', substrate: 'Matte Vinyl' },
    { sku: 'AD463-1', substrate: 'Matte Vinyl' },
    { sku: 'AD463-2', substrate: 'Matte Vinyl' },
    { sku: 'AD463-3', substrate: 'Matte Vinyl' },
    { sku: 'AD464-1', substrate: 'Matte Vinyl' },
    { sku: 'AD464-2', substrate: 'Matte Vinyl' },
    { sku: 'AD464-3', substrate: 'Matte Vinyl' }
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
