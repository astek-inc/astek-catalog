module Admin
  module DigitalProductsBySkuCsvGenerator

    require 'csv'

    class << self

      def digital_products_by_sku_csv design, include_header=true

        @design = design

        CSV.generate(headers: true) do |csv|

          if include_header
            csv << header
          end

          design.variants.each do |variant|
            @variant = variant
            csv << [@variant.sku, @design.name, @variant.name, @variant.variant_type.name, @design.collection.name]
          end

        end
      end

      def header
        ['SKU', 'Design', 'Variant', 'Variant Type', 'Collection']
      end

    end
  end
end

