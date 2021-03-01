module Admin
  module OrderLimitsCsvGenerator

    require 'csv'

    class << self

      def order_limits_csv design

        CSV.generate do |csv|

          # More than one stock item per variant means there are material options
          if design.variants.map { |v| v.stock_items }.flatten.count > design.variants.count
            design.variants.each do |variant|
              variant.stock_items.each do |i|
                if i.minimum_quantity > 1
                  csv << [variant.sku_with_substrate_and_colors(i.substrate), i.minimum_quantity]
                end
                csv << [variant.sample_sku_with_substrate(i.substrate), 1, 1]
              end

            end
          else
            design.variants.each do |variant|
              csv << [variant.sample_sku, 1, 1]
              if variant.stock_items.first.minimum_quantity > 1
                csv << [variant.sku_with_colors, variant.stock_items.first.minimum_quantity]
              end
            end
          end

        end

      end

    end

  end
end
