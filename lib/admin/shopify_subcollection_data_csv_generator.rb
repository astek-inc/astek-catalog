require "#{Rails.root}/lib/admin/base_shopify_product_data_csv_generator.rb"

module Admin
  class ShopifySubcollectionDataCsvGenerator < Admin::BaseShopifyProductDataCsvGenerator

    class << self

      def product_data_csv subcollection, website, include_header=true

        CSV.generate(headers: true) do |csv|

          if include_header
            csv << Admin::BaseShopifyProductDataCsvGenerator::HEADER
          end

          @first_row = true
          @first_variant_image

          subcollection.designs.each_with_index do |design, i|

            design.variants_for_domain(website).each do |variant|

              if i == 0
                @first_variant_image = variant.swatch_image_url(0)
              end

              variant.stock_items.for_domain(website).each do |stock_item|

                @image_index = i

                if @first_row
                  csv << Admin::BaseShopifyProductDataCsvGenerator::PRIMARY_ROW_ATTRIBUTES.map{ |attr| (attr.nil? ? nil : attribute_value(attr, stock_item, 'full', @image_index, website)) }
                  @first_row = false
                else
                  csv << Admin::BaseShopifyProductDataCsvGenerator::SECONDARY_ROW_ATTRIBUTES.map{ |attr| (attr.nil? ? nil : attribute_value(attr, stock_item, 'full', @image_index, website)) }
                end

                if website == 'astekhome.com'
                  unless design.collection.suppress_sample_option_from_display
                    csv << Admin::BaseShopifyProductDataCsvGenerator::SECONDARY_ROW_ATTRIBUTES.map { |attr| (attr.nil? ? nil : attribute_value(attr, stock_item, 'sample', 0, website)) }
                  end
                end

              end

            end
          end

        end
      end

      def attribute_value attr, stock_item, variant_type, image_index, domain, material=nil, show_image=true

        variant = stock_item.variant

        if Admin::BaseShopifyProductDataCsvGenerator::TEXT_VALUES[attr.to_sym]

          Admin::BaseShopifyProductDataCsvGenerator::TEXT_VALUES[attr.to_sym]

        elsif attr == 'handle'
          variant.design.subcollection.handle

        elsif attr == 'body'
          case domain
          when 'astek.com'
            astek_business_description stock_item, domain
          when 'astekhome.com'
            astek_home_description stock_item
          end

        elsif attr == 'tags'
          if variant_type == 'full'
            variant.design.tags domain
          end

        elsif attr == 'option_1_name'
          variant.design.subcollection.subcollection_type.name

        elsif attr == 'option_1_value'
          case variant.design.subcollection.subcollection_type.name
          when 'Roll Width'
            case domain
            when 'astek.com'
              variant.design.property('roll_width_inches') + ' inches'
            when 'astekhome.com'
              variant.design.property('roll_width_inches')
            end
          when 'Material'
            stock_item.substrate.for_domain(domain)
          end

        elsif attr == 'image_src'
          if show_image
            case variant_type
            when 'full'
              # if @random_install_image && @random_install_image[:variant_id] == design.variants.first.id
              #   @random_install_image[:install_image].file.url
              # else
              if image_index == 0
                variant.swatch_image_url 0
              end

              # end
              # when 'custom'
              #     'https://s3-us-west-2.amazonaws.com/astek-home/site-files/Product-Custom-Colorway-Swatch.png'
            else
              nil
            end
          else
            nil
          end

        elsif attr == 'image_alt_text'
          if show_image
            case variant_type
            when 'full'

              if image_index == 0

                # if design.variants.first.variant_type.name == 'Color Way'
                #   alt_text = "#{design.subcollection.name} - #{design.variants.first.name}"
                # else
                  alt_text = "#{variant.name}"
                # end

                product_type_names = variant.product_types.map { |t| t.name }
                if product_type_names.include? 'Murals'
                  alt_text += ' Mural'
                elsif product_type_names.include? 'Contact Paper'
                  alt_text += ' Contact Paper'
                elsif product_type_names.include? 'Window Film'
                  alt_text += ' Window Film'
                else
                  alt_text += ' Wallpaper'
                end

                alt_text

              end


            else
              nil
            end

          else
            nil
          end

        elsif attr == 'image_position'
          case variant_type
          when 'sample', 'custom', 'custom_sample'
            nil
          else
            if show_image && image_index == 0
              image_index + 1
            else
              nil
            end
          end

        elsif attr == 'gift_card'
          'FALSE'

        elsif attr == 'option_2_name'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            'Size'
          end

        elsif attr == 'option_2_value'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            astek_home_size_value variant_type
          end

        elsif attr == 'option_3_name'
          # case domain
          # when 'astek.com'
          #   nil
          # when 'astekhome.com'
          #   if (variant.variant_type.name == 'Color Way' || variant.design.digital?) && variant.design.user_can_select_material
          #     'Material'
          #   end
          # end

        elsif attr == 'option_3_value'
          # case domain
          # when 'astek.com'
          #   nil
          # when 'astekhome.com'
          #   if (variant.variant_type.name == 'Color Way' || variant.design.digital?) && variant.design.user_can_select_material
          #     astek_home_material_value material
          #   end
          # end

        elsif attr == 'sku'
          case variant_type
          when 'sample'
            if material
              variant.sample_sku_with_material material
            else
              variant.sample_sku
            end
          when 'custom'
            variant.design.sku+'-c'
          when 'custom_sample'
            variant.design.sku+'-c-s'
          when 'full'
            if material
              variant.sku_with_material_and_colors material
            else
              variant.sku_with_colors
            end
          end

        elsif attr == 'variant_grams'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            if variant_type == 'sample' || variant_type == 'custom_sample'
              (BigDecimal('.01') * BigDecimal('453.592')).round.to_s
            else
              variant_grams stock_item
            end
          end

        elsif attr == 'variant_inventory_qty'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            1
          end

        elsif attr == 'price'
          case domain
          when 'astek.com'
            0
          when 'astekhome.com'
            if variant_type == 'sample' || variant_type == 'custom_sample'
              # if variant.design.digital?
              #   10.99.to_s
              # else
                5.99.to_s
              # end
            else
              # if material
              #   (BigDecimal(variant.price) + BigDecimal(material.surcharge)).to_s
              # else

              stock_item.price
              # end
            end
          end

        elsif attr == 'variant_requires_shipping'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            'TRUE'
          end

        elsif attr == 'variant_taxable'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            'TRUE'
          end

        elsif attr == 'variant_weight_unit'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            'g'
          end

        elsif attr == 'variant_image'
          # if show_image
          case variant_type
          when 'full','sample'
          #   if @random_install_image && @random_install_image[:variant_id] == design.variants.first.id
          #     @random_install_image[:install_image].file.url
          #   else
            @first_variant_image
            # end
            # when 'custom','custom_sample'
            #   'https://s3-us-west-2.amazonaws.com/astek-home/site-files/Product-Custom-Colorway-Swatch.png'
          else
            nil
          end
          # else
          #   nil
          # end

        elsif attr == 'seo_title'
          variant.design.name

        elsif attr == 'collection'
          case domain
          when 'astek.com'
            unless variant.design.collection.suppress_from_display
              variant.design.collection.name
            end
          when 'astekhome.com'
            unless variant.design.collection.suppress_from_display
              variant.design.collection.name
            end
          end

        elsif attr == 'variant_compare_at_price'
          nil

        else
          val = variant.send(attr)
          if [true, false].include? val
            # The example csv file shows true and false in all caps
            val.to_s.upcase
          else
            val
          end
        end

      end

      def astek_home_description stock_item

        body = format_home_properties(stock_item).gsub(/\n+/, ' ')

        if stock_item.variant.design.subcollection.subcollection_type.name == 'Roll Width'
          body += roll_width_data_js stock_item.variant.design.subcollection
        end

        body
      end

      def roll_width_data_js subcollection
        json = subcollection.designs.map { |d| {
            sku: d.variants.first.sku_with_colors,
            width: d.property('roll_width_inches'),
            length: (d.property('roll_length_yards').to_f * 36),
            minimum_quantity: d.variants.first.stock_items.for_domain('astekhome.com').first.minimum_quantity
        } }.to_json

        '<script>
          var Astek = Astek || {};
          Astek.product_data = '+json+';
       </script>'
      end

    end

  end
end
