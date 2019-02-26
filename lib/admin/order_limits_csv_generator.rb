module Admin
  module OrderLimitsCsvGenerator

    require 'csv'

    def order_limits_csv design
      CSV.generate do |csv|
        design.variants.each do |variant|
          csv << [variant.sku + '-s', 1, 1]
          if design.minimum_quantity > 1
            csv << [variant.sku_with_colors, design.minimum_quantity]
          end
        end

        if design.user_can_select_material
          if design.minimum_quantity > 1
            csv << [design.sku + '-c', design.minimum_quantity]
          end

          csv << [design.sku + '-c-s', 1, 1]
        end
      end
    end

  end
end
