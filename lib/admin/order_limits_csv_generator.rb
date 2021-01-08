module Admin
  module OrderLimitsCsvGenerator

    require 'csv'

    class << self

      def order_limits_csv design

        CSV.generate do |csv|

          design.variants.each do |variant|
            csv << [variant.sample_sku, 1, 1]
            if variant.minimum_quantity > 1
              csv << [variant.sku_with_colors, variant.minimum_quantity]
            end
          end

          if design.user_can_select_material
            design.custom_materials.joins(:substrate).order('default_material DESC, COALESCE(substrates.display_name, substrates.name) ASC').each do |material|
              design.variants.each do |variant|
                if variant.minimum_quantity > 1
                  csv << [variant.sku_with_material_and_colors(material), design.minimum_quantity]
                end
                csv << [variant.sample_sku_with_material(material), 1, 1]
              end
            end
          end

        end

      end

    end

  end
end
