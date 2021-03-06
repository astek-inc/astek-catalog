require "#{Rails.root}/lib/admin/base_shopify_product_data_csv_generator.rb"

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

      def astek_business_description variant, domain
        body = ''

        if description = @design_alias.description
          body += format_description description
        elsif description = @design.description_for_domain(domain)
          body += format_description description
        else
          @other_domains.each do |od|
            if description = @design.description_for_domain(od)
              body += format_description description
              break
            end
          end
        end

        body += format_business_properties variant, domain

        if variant.tearsheet.file
          body += format_tearsheet_links variant
        end

        body = body.gsub(/\n+/, ' ')
        body
      end

      def astek_home_description variant
        body = format_home_properties(variant).gsub(/\n+/, ' ')
        body
      end

      def onair_design_description variant, domain
        body = ''

        if description = @design_alias.description
          body += format_description description
        elsif description = @design.description_for_domain(domain)
          body += format_description description
        else
          @other_domains.each do |od|
            if description = @design.description_for_domain(od)
              body += format_description description
              break
            end
          end
        end

        body += format_onair_properties(variant).gsub(/\n+/, ' ')
        body
      end

      def format_business_properties variant, domain
        formatted = '<div class="description__meta">'

        unless @design_alias.collection.suppress_from_display
          formatted += '<div>
              <h5>Collection</h5>
              <p><a href="/collections/'+@design_alias.collection.name.parameterize+'">'+@design_alias.collection.name+'</a></p>
            </div>'
        end

        if @design.digital?
          # This property has to apply to all variants, so we are making sure that they are all Type II.
          sis = @design.variants.map { |v| v.stock_items }.flatten!
          if sis.select { |si| si.substrate.substrate_categories.map { |sc| sc.name }.include? 'Type II' }.count == sis.count
            formatted += '<div>
              <h5>Substrate</h5>
              <p>Type II</p>
            </div>'
          end
        end

        unless @design.digital?
          if variant.stock_items.first.backing_type
            formatted += '<div>
              <h5>Backing</h5>
              <p>' + variant.stock_items.first.backing_type.name + '</p>
            </div>'
          end
        end

        formatted += '<div>
            <h5>Sold By</h5>
            <p>'+variant.stock_items.first.sale_unit.name+'</p>
          </div>'

        if variant.stock_items.first.price_code.present?
          formatted += '<div>
            <h5>Price Code</h5>
            <p>'+variant.stock_items.first.price_code+'</p>
          </div>'
        end

        @design.design_properties.each do |dp|
          next if /\Aroll_length_/ =~ dp.property.name && @design.sale_unit.name != 'Roll'
          formatted += '<div>
            <h5>'+dp.property.presentation+'</h5>
            <p>'+format_property_value(dp)+'</p>
          </div>'
        end

        formatted += '</div>'
        formatted
      end

      def format_home_properties variant

        stock_item = variant.stock_items.first

        formatted = '<!-- DESCRIPTION V2 -->
          <div class="description__meta">'

        formatted += format_dimensional_properties @design, stock_item
        formatted += format_shipping_and_returns_information @design
        formatted += format_additional_specs @design, stock_item

        formatted += '</div>'

        formatted += '<script>
            var Astek = Astek || {};
            Astek.calculator_settings = ' + stock_item.calculator_settings + ';
          </script>'

        if design = design.peel_and_stick_version
          formatted += "<script>
              var Astek = Astek || {};
              Astek.peel_and_stick_version_handle = '#{design.handle}';
            </script>"
        end

        formatted
      end

      def format_onair_properties variant
        formatted = '<div class="description__meta">'

        formatted += '<div>
              <h5>SKU</h5>
              <p>'+@design.sku+'</p>
            </div>'

        unless @design_alias.collection.suppress_from_display
          formatted += '<div>
              <h5>Collection</h5>
              <p><a href="/collections/'+@design_alias.collection.name.parameterize+'">'+@design_alias.collection.name+'</a></p>
            </div>'
        end

        formatted += '<div>
            <h5>Sold By</h5>
            <p>'+variant.stock_items.first.sale_unit.name+'</p>
          </div>'

        @design.design_properties.each do |dp|
          next unless %w[
            margin_trim
            motif_width_inches
            mural_height_inches
            mural_width_inches
            printed_width_inches
            repeat_match_type
            roll_length_meters
            roll_length_yards
            roll_width_inches
            tile_height_inches
            tile_width_inches
            vertical_repeat_inches
          ].include? dp.property.name

          next if /\Aroll_length_/ =~ dp.property.name && @design.sale_unit.name != 'Roll'

          formatted += '<div>
            <h5>'+dp.property.presentation+'</h5>
            <p>'+format_property_value(dp)+'</p>
          </div>'
        end

        formatted += '</div>'
        formatted
      end

    end

  end
end
