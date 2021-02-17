class FixImpressStockItems < ActiveRecord::Migration[5.2]

  DATA = [
    { sku: 'FH100-1', substrate: 'Smooth Topeka' },
    { sku: 'FH100-2', substrate: 'Smooth Topeka' },
    { sku: 'FH100-3', substrate: 'Smooth Topeka' },
    { sku: 'FH101-1', substrate: 'Smooth Topeka' },
    { sku: 'FH101-2', substrate: 'Smooth Topeka' },
    { sku: 'FH101-3', substrate: 'Smooth Topeka' },
    { sku: 'FH102-1', substrate: 'Smooth Topeka' },
    { sku: 'FH102-2', substrate: 'Smooth Topeka' },
    { sku: 'FH102-3', substrate: 'Smooth Topeka' },
    { sku: 'FH102-4', substrate: 'Smooth Topeka' },
    { sku: 'FH103-1', substrate: 'Smooth Topeka' },
    { sku: 'FH103-2', substrate: 'Smooth Topeka' },
    { sku: 'FH103-3', substrate: 'Smooth Topeka' },
    { sku: 'FH103-4', substrate: 'Smooth Topeka' },
    { sku: 'FH104-1', substrate: 'Smooth Topeka' },
    { sku: 'FH104-2', substrate: 'Smooth Topeka' },
    { sku: 'FH104-3', substrate: 'Smooth Topeka' },
    { sku: 'FH104-4', substrate: 'Smooth Topeka' },
    { sku: 'FH105', substrate: 'Smooth Topeka' },
    { sku: 'FH106-1', substrate: 'Smooth Topeka' },
    { sku: 'FH106-2', substrate: 'Smooth Topeka' },
    { sku: 'FH106-3', substrate: 'Smooth Topeka' },
    { sku: 'FH106-4', substrate: 'Smooth Topeka' },
    { sku: 'FH107-1', substrate: 'Smooth Topeka' },
    { sku: 'FH107-2', substrate: 'Smooth Topeka' },
    { sku: 'FH107-3', substrate: 'Smooth Topeka' },
    { sku: 'FH108-1', substrate: 'Smooth Topeka' },
    { sku: 'FH108-2', substrate: 'Smooth Topeka' },
    { sku: 'FH108-3', substrate: 'Smooth Topeka' },
    { sku: 'FH108-4', substrate: 'Smooth Topeka' },
    { sku: 'FH108-5', substrate: 'Smooth Topeka' },
    { sku: 'FH109-1', substrate: 'Smooth Topeka' },
    { sku: 'FH109-2', substrate: 'Smooth Topeka' },
    { sku: 'FH109-3', substrate: 'Smooth Topeka' },
    { sku: 'FH109-4', substrate: 'Smooth Topeka' },
    { sku: 'FH110-1', substrate: 'Smooth Topeka' },
    { sku: 'FH110-2', substrate: 'Smooth Topeka' },
    { sku: 'FH110-3', substrate: 'Smooth Topeka' },
    { sku: 'FH111-1', substrate: 'Smooth Topeka' },
    { sku: 'FH111-2', substrate: 'Smooth Topeka' },
    { sku: 'FH111-3', substrate: 'Smooth Topeka' },
    { sku: 'FH112-1', substrate: 'Smooth Topeka' },
    { sku: 'FH112-2', substrate: 'Smooth Topeka' },
    { sku: 'FH112-3', substrate: 'Smooth Topeka' },
    { sku: 'FH112-4', substrate: 'Smooth Topeka' },
    { sku: 'FH112-5', substrate: 'Smooth Topeka' }
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
