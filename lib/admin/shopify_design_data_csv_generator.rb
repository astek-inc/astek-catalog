module Admin
  class ShopifyDesignDataCsvGenerator < Admin::BaseShopifyProductDataCsvGenerator

    class << self

      def product_data_csv design, website, include_header=true

        CSV.generate(headers: true) do |csv|

          if include_header
            csv << Admin::BaseShopifyProductDataCsvGenerator::HEADER
          end

          total_image_count = design.variants_for_domain(website).count + design.variants_for_domain(website).select { |v| v.install_images_for_domain(website).any? }.count

          @custom_image_index = total_image_count
          # puts 'custom image index: '+@custom_image_index.to_s

          @first_row = true

          # On astekhome.com, if a design has colorways, we don't show the install images separately.
          # Instead, we mix a random install image in with the swatch images
          @random_install_image = nil
          if website == 'astekhome.com' && design.has_colorways?
            if install_images = design.install_images_for_domain(website)
              @random_install_image = install_images.sample
            end
          end

          design.variants_for_domain(website).each_with_index do |variant, i|
            
            @image_index = i
            first_variant_row = true

            full_variant_type = 'full'
            sample_variant_type = 'sample'
            substrate = nil
            stock_item_count = variant.stock_items.for_domain(website).count

            if stock_item_count > 1
              full_variant_type = 'full-substrate'
              sample_variant_type = 'sample-substrate'
            end

            variant.stock_items.rank(:row_order).for_domain(website).each do |stock_item|

              if design.digital? && stock_item_count > 1
                substrate = stock_item.substrate
              end

              if @first_row
                csv << Admin::BaseShopifyProductDataCsvGenerator::PRIMARY_ROW_ATTRIBUTES.map{ |attr| (attr.nil? ? nil : attribute_value(attr, stock_item, full_variant_type, @image_index, website, nil, first_variant_row, substrate)) }
                @first_row = false
              else
                csv << Admin::BaseShopifyProductDataCsvGenerator::SECONDARY_ROW_ATTRIBUTES.map{ |attr| (attr.nil? ? nil : attribute_value(attr, stock_item, full_variant_type, @image_index, website, nil, first_variant_row, substrate)) }
              end
              first_variant_row = false

              if website == 'astekhome.com'
                murals = ProductType.find_by(name: 'Murals')
                unless design.collection.suppress_sample_option_from_display || (design.distributed? && variant.product_types.include?(murals))
                  csv << Admin::BaseShopifyProductDataCsvGenerator::SECONDARY_ROW_ATTRIBUTES.map { |attr| (attr.nil? ? nil : attribute_value(attr, stock_item, sample_variant_type, 0, website, nil, nil, substrate)) }
                end
              end

            end
            
          end

          # This is for astek.com, and astekhome.com designs which don't have colorways.
          # On astekhome.com, if a design has colorways, we don't show the install images separately,
          # we mix a random install image in with the swatch images (handled above @line 170).
          if website == 'astek.com' || (website == 'astekhome.com' && !design.has_colorways?)
            design.variants_for_domain(website).each do |v|
              if v.install_images_for_domain(website)
                v.install_images_for_domain(website).each do |image|
                  @image_index += 1
                  csv << [design.handle] + 23.times.map { nil } + [image.file.url, @image_index + 1] + 22.times.map { nil }
                end
              end
            end
          end

        end
      end

      def attribute_value attr, stock_item, variant_type, image_index, domain, custom_material=nil, show_image=true, substrate=nil

        variant = stock_item.variant

        if Admin::BaseShopifyProductDataCsvGenerator::TEXT_VALUES[attr.to_sym]

          Admin::BaseShopifyProductDataCsvGenerator::TEXT_VALUES[attr.to_sym]

        elsif attr == 'handle'
          variant.design.handle

        elsif attr == 'body'
          body_for_domain stock_item, domain

        elsif attr == 'type'
          variant.type

        elsif attr == 'tags'
          if /\Afull/ =~ variant_type
          # if variant_type == 'full'
          variant.design.tags domain
          end

        elsif attr == 'option_1_name'
          case domain
          when 'astek.com'
            'Colorway'
          when 'astekhome.com'
            if variant.variant_type.name == 'Color Way' || variant.design.digital?
             'Colorway'
            else
              'Size'
            end
          when 'onairdesign.com'
            if variant.variant_type.name == 'Color Way'
              'Colorway'
            else
              'Title'
            end
          end

        elsif attr == 'option_1_value'
          case domain
          when 'astek.com'
            case variant_type
            when 'custom', 'custom_sample'
              'Custom'
            else
              variant.name
            end
          when 'astekhome.com'
            if variant.variant_type.name == 'Color Way' || variant.design.digital?
              astek_home_colorway_value variant_type, variant.name
            else
              astek_home_size_value variant_type
            end
          when 'onairdesign.com'
            if variant.variant_type.name == 'Color Way'
              variant.name
            else
              'Default Title'
            end
          end

        elsif attr == 'image_src'
          if show_image
            if /\Afull/ =~ variant_type
              if @random_install_image && @random_install_image[:variant_id] == variant.id
                @random_install_image[:install_image].file.url
              else
                variant.swatch_image_url 0
              end
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
            if /\Afull/ =~ variant_type

              if variant.variant_type.name == 'Color Way'
                alt_text = "#{variant.design.name} - #{variant.name}"
              else
                alt_text = "#{variant.name}"
              end

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

            else
              nil
            end

          else
            nil
          end

        elsif attr == 'image_position'
          if /\A(sample|custom|custom_sample)/ =~ variant_type
            nil
          else
            if show_image
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
            if /-substrate\z/ =~ variant_type
              'Size'
            #  'Material'
            elsif variant.variant_type.name == 'Color Way' || variant.design.digital?
              'Size'
            # else
            #   if variant.design.user_can_select_material
            #     'Material'
            #   end
            end
          when 'onairdesign.com'
            nil
          end

        elsif attr == 'option_2_value'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            if /-substrate\z/ =~ variant_type
              # substrate.name_or_display_name
              astek_home_size_value variant_type
            elsif variant.variant_type.name == 'Color Way' || variant.design.digital?
              astek_home_size_value variant_type
            # else
            #   astek_home_custom_material_value custom_material
            end
          when 'onairdesign.com'
            nil
          end

        elsif attr == 'option_3_name'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            if /-substrate\z/ =~ variant_type
              'Material'
            # elsif (variant.variant_type.name == 'Color Way' || variant.design.digital?) && variant.stock_items.for_domain('astekhome.com') > 1
            #   'Material'
            end
          when 'onairdesign.com'
            nil
          end

        elsif attr == 'option_3_value'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            if /-substrate\z/ =~ variant_type
              # astek_home_size_value variant_type
              substrate.name_or_display_name
            # elsif (variant.variant_type.name == 'Color Way' || variant.design.digital?) && variant.stock_items.for_domain('astekhome.com') > 1
            #   astek_home_custom_material_value custom_material
            end
          when 'onairdesign.com'
            nil
          end

        elsif attr == 'sku'
          if /\Asample/ =~ variant_type
            if substrate
              variant.sample_sku_with_substrate substrate
            elsif custom_material
              variant.sample_sku_with_custom_material custom_material
            else
              variant.sample_sku
            end
          elsif variant_type == 'custom'
              variant.design.sku+'-c'
          elsif variant_type ==  'custom_sample'
              variant.design.sku+'-c-s'
          elsif /\Afull/ =~ variant_type
            case domain
            when 'onairdesign.com'
              variant.sku
            else
              if substrate
                variant.sku_with_substrate_and_colors substrate
              elsif custom_material
                variant.sku_with_custom_material_and_colors custom_material
              else
                variant.sku_with_colors
              end
            end
          end

        elsif attr == 'variant_grams'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            if /sample/ =~ variant_type
              (BigDecimal(Admin::BaseShopifyProductDataCsvGenerator::SAMPLE_WEIGHT, 0) * BigDecimal('453.592', 0)).round.to_s
            else
              if custom_material
                custom_material_stock_item_weight custom_material, stock_item
              else
                variant_grams stock_item
              end
            end
          when 'onairdesign.com'
            nil
          else
            nil
          end

        elsif attr == 'variant_inventory_qty'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            1
          when 'onairdesign.com'
            nil
          end

        elsif attr == 'price'
          case domain
          when 'astek.com'
            0
          when 'astekhome.com'
            if /sample/ =~ variant_type
              if variant.design.digital?
                Admin::BaseShopifyProductDataCsvGenerator::SAMPLE_PRICE_DIGITAL
              else
                Admin::BaseShopifyProductDataCsvGenerator::SAMPLE_PRICE_DISTRIBUTED
              end
            else

              # If there is a sale price indicated, we need to put that here and put
              # the regular retail price in the compare_at_price column
              if stock_item.sale_price.present? && stock_item.display_sale_price
                display_price = stock_item.sale_price
              else
                display_price = stock_item.price
              end

              if custom_material
                (BigDecimal(display_price, 0) + BigDecimal(custom_material.surcharge, 0)).to_s
              else
                if display_price.blank?
                  0
                else
                  display_price
                end
              end

            end

          when 'onairdesign.com'
            0
          end

        elsif attr == 'variant_compare_at_price'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'

            if /sample/ =~ variant_type
              nil
            else

              # If there is a sale price indicated, we need to put the regular retail price here
              # and put the sale price in the price column
              if stock_item.sale_price.present? && stock_item.display_sale_price

                if custom_material
                  (BigDecimal(stock_item.price, 0) + BigDecimal(custom_material.surcharge, 0)).to_s
                else
                  if stock_item.price.blank?
                    0
                  else
                    stock_item.price
                  end
                end

              else

                nil

              end

            end

          when 'onairdesign.com'
            nil
          end

        elsif attr == 'variant_requires_shipping'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            'TRUE'
          when 'onairdesign.com'
            nil
          end

        elsif attr == 'variant_taxable'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            'TRUE'
          when 'onairdesign.com'
            nil
          end

        elsif attr == 'variant_weight_unit'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            'g'
          when 'onairdesign.com'
            nil
          end

        elsif attr == 'variant_image'
          # if show_image
            if /full|sample/ =~ variant_type
              if @random_install_image && @random_install_image[:variant_id] == variant.id
                @random_install_image[:install_image].file.url
              else
                variant.swatch_image_url 0
              end
            # when 'custom','custom_sample'
            #   'https://s3-us-west-2.amazonaws.com/astek-home/site-files/Product-Custom-Colorway-Swatch.png'
            else
              nil
            end
          # else
          #   nil
          # end

        elsif attr == 'seo_title'
          if variant.design.collection.prepend_collection_name_to_design_names
            variant.design.collection.name + ' | ' + variant.design.name
          elsif variant.design.collection.append_collection_name_to_design_names
            variant.design.name + ' | ' + variant.design.collection.name
          else
            variant.design.name
          end

        elsif attr == 'seo_description'
          variant.design.description_for_domain domain

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
          when 'onairdesign.com'
            unless variant.design.collection.suppress_from_display
              variant.design.collection.name
            end
          end

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

    end

  end
end
