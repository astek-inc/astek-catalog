module Admin
  class ShopifyDesignAliasDataCsvGenerator < Admin::BaseShopifyProductDataCsvGenerator

    class << self

      def product_data_csv design_alias, domain, include_header=true

        @design_alias = design_alias
        @design = @design_alias.design
        @other_domains = Website.where.not('domain = ?', domain).map { |w| w.domain }

        CSV.generate(headers: true) do |csv|

          if include_header
            csv << Admin::BaseShopifyProductDataCsvGenerator::HEADER
          end

          # If there aren't any images assigned to this specific domain, use the first ones we can find
          total_image_count = @design.variants_for_domain(domain).count + @design.variants_for_domain(domain).select { |v| v.install_images_for_domain(domain).any? }.count
          if total_image_count == 0
            @other_domains.each do |od|
              if total_image_count = @design.variants_for_domain(od).count + @design.variants_for_domain(od).select { |v| v.install_images_for_domain(od).any? }.count
                @other_domain = od
                break
              end
            end
          end

          puts '= * ~ | '*30
          puts @other_domains
          puts @other_domain
          puts total_image_count
          puts '= * ~ | '*30

          @custom_image_index = total_image_count
          @first_row = true

          # On astekhome.com, if a design has colorways, we don't show the install images separately.
          # Instead, we mix a random install image in with the swatch images
          @random_install_image = nil
          if domain == 'astekhome.com' && @design.has_colorways?
            if install_images = @design.install_images_for_domain
              @random_install_image = install_images.sample
            end
          end

          @design.variants.each_with_index do |variant, i|
            
            @image_index = i
            first_variant_row = true

            if domain == 'astekhome.com' && @design.user_can_select_material

              @design.custom_materials.joins(:substrate).order('default_material DESC, COALESCE(substrates.display_name, substrates.name) ASC').each do |material|

                if @first_row
                  csv << Admin::BaseShopifyProductDataCsvGenerator::PRIMARY_ROW_ATTRIBUTES.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'full', @image_index, domain, material, first_variant_row)) }
                  @first_row = false
                else
                  csv << Admin::BaseShopifyProductDataCsvGenerator::SECONDARY_ROW_ATTRIBUTES.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'full', @image_index, domain, material, first_variant_row)) }
                end
                first_variant_row = false

                unless @design.collection.suppress_sample_option_from_display
                  csv << Admin::BaseShopifyProductDataCsvGenerator::SECONDARY_ROW_ATTRIBUTES.map { |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'sample', 0, domain, material)) }
                end

              end

            else
              if @first_row
                csv << primary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'full', @image_index, domain)) }
                @first_row = false
              else
                csv << Admin::BaseShopifyProductDataCsvGenerator::SECONDARY_ROW_ATTRIBUTES.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'full', @image_index, domain)) }
              end

              if domain == 'astekhome.com'
                unless @design.collection.suppress_sample_option_from_display
                  csv << Admin::BaseShopifyProductDataCsvGenerator::SECONDARY_ROW_ATTRIBUTES.map { |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'sample', 0, domain)) }
                end
              end
            end
          end

          # This is for astek.com, and astekhome.com designs which don't have colorways.
          # On astekhome.com, if a design has colorways, we don't show the install images separately,
          # we mix a random install image in with the swatch images (handled above @line 170).
          if domain == 'astek.com' || (domain == 'astekhome.com' && !@design.has_colorways?)
            @design.variants.each do |variant|
              if variant.install_images
                variant.install_images.each do |image|
                  @image_index += 1
                  csv << [@design.handle] + 23.times.map { nil } + [image.file.url, @image_index + 1] + 22.times.map { nil }

                end
              end
            end
          end
        end

      end

      def attribute_value attr, variant, variant_type, image_index, domain, material=nil, show_image=true

        if Admin::BaseShopifyProductDataCsvGenerator::TEXT_VALUES[attr.to_sym]

          Admin::BaseShopifyProductDataCsvGenerator::TEXT_VALUES[attr.to_sym]

        elsif attr == 'handle'
          @design_alias.handle

        elsif attr == 'body'
          body_for_domain variant, domain

        elsif attr == 'type'
          variant.type

        elsif attr == 'tags'
          if variant_type == 'full'
            @design.tags domain
          end

        elsif attr == 'option_1_name'
          case domain
          when 'astek.com'
            'Colorway'
          when 'astekhome.com'
            if variant.variant_type.name == 'Color Way' || @design.digital?
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
            if variant.variant_type.name == 'Color Way' || @design.digital?
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
            case variant_type
            when 'full'
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
            case variant_type
            when 'full'

              if variant.variant_type.name == 'Color Way'
                alt_text = "#{@design.name} - #{variant.name}"
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
          case variant_type
          when 'sample', 'custom', 'custom_sample'
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
            if variant.variant_type.name == 'Color Way' || @design.digital?
              'Size'
            else
              if @design.user_can_select_material
                'Material'
              end
            end
          when 'onairdesign.com'
            nil
          end

        elsif attr == 'option_2_value'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            if variant.variant_type.name == 'Color Way' || @design.digital?
              astek_home_size_value variant_type
            else
              astek_home_material_value material
            end
          when 'onairdesign.com'
            nil
          end

        elsif attr == 'option_3_name'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            if (variant.variant_type.name == 'Color Way' || @design.digital?) && @design.user_can_select_material
              'Material'
            end
          when 'onairdesign.com'
            nil
          end

        elsif attr == 'option_3_value'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            if (variant.variant_type.name == 'Color Way' || @design.digital?) && @design.user_can_select_material
              astek_home_material_value material
            end
          when 'onairdesign.com'
            nil
          end

        elsif attr == 'sku'
          case variant_type
          when 'sample'
            if material
              variant.sample_sku_with_material material
            else
              variant.sample_sku
            end
          when 'custom'
            @design.sku+'-c'
          when 'custom_sample'
            @design.sku+'-c-s'
          when 'full'

            case domain
            when 'onairdesign.com'
              variant.sku
            else
              if material
                variant.sku_with_material_and_colors material
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
            if variant_type == 'sample' || variant_type == 'custom_sample'
              (BigDecimal(Admin::BaseShopifyProductDataCsvGenerator::SAMPLE_WEIGHT, 0) * BigDecimal('453.592', 0)).round.to_s
            else
              if material
                material_variant_weight material, variant
              else
                variant.variant_grams
              end
            end
          when 'onairdesign.com'
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
            if variant_type == 'sample' || variant_type == 'custom_sample'
              if @design.digital?
                Admin::BaseShopifyProductDataCsvGenerator::SAMPLE_PRICE_DIGITAL
              else
                Admin::BaseShopifyProductDataCsvGenerator::SAMPLE_PRICE_DISTRIBUTED
              end
            else
              if material
                (BigDecimal(variant.price, 0) + BigDecimal(material.surcharge, 0)).to_s
              else
                variant.price
              end
            end
          when 'onairdesign.com'
            0
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
            case variant_type
            when 'full','sample'
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
          @design.name

        elsif attr == 'seo_description'
          unless seo_description = @design.description_for_domain(domain)
            @other_domains.each do |od|
              if seo_description = @design.description_for_domain(od)
                break
              end
            end
          end
          seo_description

        elsif attr == 'collection'
          unless @design_alias.collection.suppress_from_display
            @design_alias.collection.name
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
