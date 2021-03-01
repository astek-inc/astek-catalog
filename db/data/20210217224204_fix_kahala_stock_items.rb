class FixKahalaStockItems < ActiveRecord::Migration[5.2]
  def up

    astek_business = Website.find_by(domain: 'astek.com')
    astek_home = Website.find_by(domain: 'astekhome.com')

    Collection.find_by(name: 'Kahala').designs.each do |d|
      d.variants.each do |v|

        v.stock_items.each do |si|
          if si.substrate.name == 'Smooth Topeka'

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

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
