module Admin
  module FedexCrossborderCsvGenerator

    SAMPLE_PRICE_DIGITAL = 10.99
    SAMPLE_PRICE_IN_STOCK = 5.99
    SAMPLE_PACKAGE_DIMENSIONS = { width: 3, height: 3, depth: 30 }
    SAMPLE_WEIGHT = 0.01

    PAPER_PACKAGE_DEPTH = 61
    NON_PAPER_PACKAGE_DEPTH = 54

    require 'csv'

    @design
    @variant
    @stock_item
    @material
    @substrate
    @sample

    class << self

      def fedex_crossborder_csv design, include_header = true

        @design = design

        CSV.generate(headers: true) do |csv|

          if include_header
            csv << header
          end

          design.variants_for_domain('astekhome.com').each do |variant|

            @variant = variant


            if design.user_can_select_material

              design.custom_materials.joins(:substrate).order('default_material DESC, COALESCE(substrates.display_name, substrates.name) ASC').each do |material|

                @stock_item = variant.stock_items.for_domain('astekhome.com').first
                @material = material

                @sample = false
                csv << [composition, product_name, product_type, language, product_id, product_description, url, image_url, price, origin_country, hs_code, eccn, haz, license_flag, import_flag, item_export_hub_country, l1, w1, h1, wt1, l2, w2, h2, wt2, l3, w3, h3, wt3, l4, w4, h4, wt4]

                @sample = true
                csv << [composition, product_name, product_type, language, product_id, product_description, url, image_url, price, origin_country, hs_code, eccn, haz, license_flag, import_flag, item_export_hub_country, l1, w1, h1, wt1, l2, w2, h2, wt2, l3, w3, h3, wt3, l4, w4, h4, wt4]

              end

              @material = nil

            else

              variant.stock_items.for_domain('astekhome.com').each do |stock_item|

                @stock_item = stock_item
                @substrate = stock_item.substrate

                @sample = false
                csv << [composition, product_name, product_type, language, product_id, product_description, url, image_url, price, origin_country, hs_code, eccn, haz, license_flag, import_flag, item_export_hub_country, l1, w1, h1, wt1, l2, w2, h2, wt2, l3, w3, h3, wt3, l4, w4, h4, wt4]

                @sample = true
                csv << [composition, product_name, product_type, language, product_id, product_description, url, image_url, price, origin_country, hs_code, eccn, haz, license_flag, import_flag, item_export_hub_country, l1, w1, h1, wt1, l2, w2, h2, wt2, l3, w3, h3, wt3, l4, w4, h4, wt4]

              end

              @substrate = nil

            end

          end
        end

      end

      def header
        %w[composition productName productType language productId productDescription url imageUrl price originCountry hsCode ECCN haz licenseFlag importFlag itemExportHubCountry L1 W1 H1 WT1 L2 W2 H2 WT2 L3 W3 H3 WT3 L4 W4 H4 WT4]
      end

      def composition
        nil
      end

      def product_name
        product_description
      end

      def product_type
        names = @variant.product_types.map { |t| t.name }
        if names.include? 'Contact Paper'
          'Contact Paper'
        elsif names.include? 'Window Film'
          'Window Film'
        else
          'Wallcovering'
        end
      end

      def language
        'en'
      end

      def product_id
        if @material

          if @sample
            @variant.sample_sku_with_custom_material @material
          else
            @variant.sku_with_custom_material_and_colors @material
          end

        elsif @substrate

          if @sample
            @variant.sample_sku_with_substrate @substrate
          else
            @variant.sku_with_substrate_and_colors @substrate
          end

        else

          if @sample
            @variant.sample_sku
          else
            @variant.sku_with_colors
          end

        end
      end

      def product_description
        product_types = @variant.product_types.map { |t| t.name }

        description = full_product_name + ' - '

        case @design.collection.product_category.name
        when 'Digital'
          if product_types.include? 'Murals'
            description += 'Digitally printed mural'
          else
            description += 'Digitally printed wallcovering'
          end

        when 'Naturals'
          description += 'In-stock natural wallcovering'

        when 'Specialty'
          if product_types.include? 'Contact Paper'
            description += 'In-stock contact paper'
          elsif product_types.include? 'Window Film'
            description += 'In-stock window film'
          else
            description += 'In-stock specialty wallcovering'
          end

        end

        if @sample
          description += ' sample'
        end

        description += ' (' + product_type + ')'

        description
      end

      def url
        nil
      end

      def image_url
        nil
      end

      def price
        if @sample
          if @design.digital?
            SAMPLE_PRICE_DIGITAL
          else
            SAMPLE_PRICE_IN_STOCK
          end
        else
          @stock_item.price
        end
      end

      def origin_country
        @design.country_of_origin.iso.present? ? @design.country_of_origin.iso : 'US'
      end

      def hs_code
        nil
      end

      def eccn
        nil
      end

      def haz
        0
      end

      def license_flag
        nil
      end

      def import_flag
        nil
      end

      def item_export_hub_country
        nil
      end

      def l1
        if @sample
          SAMPLE_PACKAGE_DIMENSIONS[:depth]
        else
          if @material
            if @material.name == 'Paper'
              PAPER_PACKAGE_DEPTH
            else
              NON_PAPER_PACKAGE_DEPTH
            end
          else
            @stock_item.depth
          end
        end
      end

      def w1
        if @sample
          SAMPLE_PACKAGE_DIMENSIONS[:width]
        else
          @stock_item.width
        end
      end

      def h1
        if @sample
          SAMPLE_PACKAGE_DIMENSIONS[:height]
        else
          @stock_item.height
        end
      end

      def wt1
        if @sample
          SAMPLE_WEIGHT
        else
          if @material
            material_variant_weight
          else
            @stock_item.weight
          end
        end
      end

      def l2
        nil
      end

      def w2
        nil
      end

      def h2
        nil
      end

      def wt2
        nil
      end

      def l3
        nil
      end

      def w3
        nil
      end

      def h3
        nil
      end

      def wt3
        nil
      end

      def l4
        nil
      end

      def w4
        nil
      end

      def h4
        nil
      end

      def wt4
        nil
      end

      def full_product_name
        if @design.name == @variant.name
          @variant.name
        else
          "#{@design.name} - #{@variant.name}"
        end
      end

      # If the printed width of a given design is less than standard, more physical material
      # may be required to complete a given order, so the weight of a square foot of a variant
      # is given as more than standard. We want to apply the same increase to the custom material
      # options
      def material_variant_weight
        if BigDecimal(@stock_item.weight, 0) == BigDecimal(@variant.variant_substrates.for_domain('astekhome.com').first.substrate.weight_per_square_foot, 0)
          BigDecimal(@material.substrate.weight_per_square_foot, 0)
        else
          ratio = BigDecimal(@stock_item.weight, 0) / BigDecimal(@stock_item.substrate.weight_per_square_foot, 0)
          (BigDecimal(@material.substrate.weight_per_square_foot, 0) * ratio)
        end
      end

    end
    
  end
end
