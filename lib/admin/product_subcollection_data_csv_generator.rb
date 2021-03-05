module Admin
  class ProductSubcollectionDataCsvGenerator < Admin::BaseProductDataCsvGenerator

    # require 'csv'

    # TEXT_VALUES = {
    #     variant_barcode: '',
    #     variant_inventory_tracker: '',
    #     variant_inventory_policy: 'Continue',
    #     variant_fulfillment_service: 'Manual',
    #     variant_compare_at_price: '',
    #     google_shopping_mpn: '',
    #     google_shopping_age_group: '',
    #     google_shopping_gender: '',
    #     google_shopping_google_product_category: '',
    #     google_shopping_adwords_grouping: '',
    #     google_shopping_adwords_labels: '',
    #     google_shopping_condition: '',
    #     google_shopping_custom_product: '',
    #     google_shopping_custom_label_0: '',
    #     google_shopping_custom_label_1: '',
    #     google_shopping_custom_label_2: '',
    #     google_shopping_custom_label_3: '',
    #     google_shopping_custom_label_4: '',
    #     variant_tax_code: '',
    #     cost_per_item: ''
    # }

    # PRIMARY_ROW_ATTRIBUTES = %w[
    #   handle
    #   title
    #   body
    #   vendor
    #   type
    #   tags
    #   published?
    #   option_1_name
    #   option_1_value
    #   option_2_name
    #   option_2_value
    #   option_3_name
    #   option_3_value
    #   sku
    #   variant_grams
    #   variant_inventory_tracker
    #   variant_inventory_qty
    #   variant_inventory_policy
    #   variant_fulfillment_service
    #   price
    #   variant_compare_at_price
    #   variant_requires_shipping
    #   variant_taxable
    #   variant_barcode
    #   image_src
    #   image_position
    #   image_alt_text
    #   gift_card
    #   google_shopping_mpn
    #   google_shopping_age_group
    #   google_shopping_gender
    #   google_shopping_google_product_category
    #   seo_title
    #   description
    #   google_shopping_adwords_grouping
    #   google_shopping_adwords_labels
    #   google_shopping_condition
    #   google_shopping_custom_product
    #   google_shopping_custom_label_0
    #   google_shopping_custom_label_1
    #   google_shopping_custom_label_2
    #   google_shopping_custom_label_3
    #   google_shopping_custom_label_4
    #   variant_image
    #   variant_weight_unit
    #   variant_tax_code
    #   cost_per_item
    #   collection
    # ]

    class << self

      def product_data_csv subcollection, website, include_header=true

        CSV.generate(headers: true) do |csv|

          if include_header
            csv << BaseProductDataCsvGenerator::HEADER
          end

          # total_image_count = subcollection.designs.variants.count + subcollection.designs.variants.select { |v| v.variant_install_images.any? }.count
          # @custom_image_index = total_image_count
          @first_row = true

          # # On astekhome.com, if a design has colorways, we don't show the install images separately.
          # # Instead, we mix a random install image in with the swatch images
          # @random_install_image = nil
          # if website == 'astekhome.com' && variant.design.has_colorways?
          #   if install_images = subcollection.install_images
          #     @random_install_image = install_images.sample
          #   end
          # end

          subcollection.designs.each_with_index do |design, i|

            design.variants_for_domain(website).each do |variant, j|

              variant.stock_items.for_domain(website).each do |stock_item|

                @image_index = i

                # first_variant_row = true

                # if website == 'astekhome.com' && design.user_can_select_material
                #
                #   design.custom_materials.joins(:substrate).order('default_material DESC, COALESCE(substrates.display_name, substrates.name) ASC').each do |material|
                #
                #     if @first_row
                #       csv << primary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'full', @image_index, website, material, first_variant_row)) }
                #       @first_row = false
                #     else
                #       csv << secondary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'full', @image_index, website, material, first_variant_row)) }
                #     end
                #     first_variant_row = false
                #
                #     unless design.collection.suppress_sample_option_from_display
                #       csv << secondary_row_attributes.map { |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'sample', 0, website, material)) }
                #     end
                #
                #   end
                #
                # else

                if @first_row
                  csv << BaseProductDataCsvGenerator::PRIMARY_ROW_ATTRIBUTES.map{ |attr| (attr.nil? ? nil : attribute_value(attr, stock_item, 'full', @image_index, website)) }
                  @first_row = false
                else
                  csv << BaseProductDataCsvGenerator::SECONDARY_ROW_ATTRIBUTES.map{ |attr| (attr.nil? ? nil : attribute_value(attr, stock_item, 'full', @image_index, website)) }
                end

                if website == 'astekhome.com'
                  unless design.collection.suppress_sample_option_from_display
                    csv << BaseProductDataCsvGenerator::SECONDARY_ROW_ATTRIBUTES.map { |attr| (attr.nil? ? nil : attribute_value(attr, stock_item, 'sample', 0, website)) }
                  end
                end
              # end

            end

          end

          # # On astekhome.com, if a design has colorways, we don't show the install images separately, we mix a random install image in with the swatch images
          # if website == 'astek.com' || (website == 'astekhome.com' && !design.has_colorways?)
          #   design.variants.each do |variant|
          #     if variant.variant_install_images
          #       variant.variant_install_images.each do |image|
          #         @image_index += 1
          #         csv << ['D-'+design.sku] + 23.times.map { nil } + [image.file.url, @image_index + 1] + 21.times.map { nil }
          #
          #       end
          #     end
          #   end
          # end
        end

        end
      end


      def attribute_value attr, stock_item, variant_type, image_index, domain, material=nil, show_image=true

        if BaseProductDataCsvGenerator::TEXT_VALUES[attr.to_sym]

          BaseProductDataCsvGenerator::TEXT_VALUES[attr.to_sym]

        elsif attr == 'handle'
          stock_item.variant.design.subcollection.handle

        elsif attr == 'body'
          case domain
          when 'astek.com'
            astek_business_description stock_item, domain
          when 'astekhome.com'
            astek_home_description stock_item
          end

        elsif attr == 'tags'
          if variant_type == 'full'
            stock_item.variant.design.tags domain
          end

        elsif attr == 'option_1_name'
          stock_item.variant.design.subcollection.subcollection_type.name

        elsif attr == 'option_1_value'
          case stock_item.variant.design.subcollection.subcollection_type.name
          when 'Roll Width'
            case domain
            when 'astek.com'
              stock_item.variant.design.property('roll_width_inches') + ' inches'
            when 'astekhome.com'
              stock_item.variant.design.property('roll_width_inches')
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
                stock_item.variant.swatch_image_url 0
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
                  alt_text = "#{stock_item.variant.name}"
                # end

                product_type_names = stock_item.variant.product_types.map { |t| t.name }
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
              stock_item.variant.sample_sku_with_material material
            else
              stock_item.variant.sample_sku
            end
          when 'custom'
            stock_item.variant.design.sku+'-c'
          when 'custom_sample'
            stock_item.variant.design.sku+'-c-s'
          when 'full'
            if material
              stock_item.variant.sku_with_material_and_colors material
            else
              stock_item.variant.sku_with_colors
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
          stock_item.variant.swatch_image_url 0
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
          stock_item.variant.design.name

        elsif attr == 'collection'
          case domain
          when 'astek.com'
            unless stock_item.variant.design.collection.suppress_from_display
              stock_item.variant.design.collection.name
            end
          when 'astekhome.com'
            unless stock_item.variant.design.collection.suppress_from_display
              stock_item.variant.design.collection.name
            end
          end

        elsif attr == 'variant_compare_at_price'
          nil

        else
          val = stock_item.variant.send(attr)
          if [true, false].include? val
            # The example csv file shows true and false in all caps
            val.to_s.upcase
          else
            val
          end
        end

      end

      def astek_home_colorway_value variant_type, variant_name
        case variant_type
        when 'custom', 'custom_sample'
          'Custom'
        else
          variant_name
        end
      end

      def astek_home_size_value variant_type
        case variant_type
        when 'sample', 'full'
          variant_type.capitalize
        when 'custom_sample'
          'Sample'
        else
          'Full'
        end
      end

      def astek_home_material_value material
        if material
          material.name
        end
      end

      def astek_business_description stock_item, domain
        body = ''

        if formatted_description = format_description(stock_item, domain)
          body += formatted_description
        end

        body += format_business_properties(stock_item) #, domain)

        if stock_item.variant.tearsheet.file
          body += format_tearsheet_links stock_item
        end

        body = body.gsub(/\n+/, ' ')
        body
      end

      def astek_home_description stock_item

        body = format_home_properties(stock_item).gsub(/\n+/, ' ')

        if stock_item.variant.design.subcollection.subcollection_type.name == 'Roll Width'
          body += roll_width_data_js stock_item.variant.design.subcollection
        end

        body
      end

      def format_description(stock_item, domain)
        formatted_description = ''
        if description = stock_item.variant.design.description_for_domain(domain)
          formatted_description += '<p>' + description + '</p>'
        end
      end

      def format_business_properties stock_item

        variant = stock_item.variant
        design = variant.design

        formatted = '<div class="description__meta">'

        unless variant.design.collection.suppress_from_display
          formatted += '<div>
              <h5>Collection</h5>
              <p><a href="/collections/'+variant.design.collection.name.parameterize+'">'+variant.design.collection.name+'</a></p>
            </div>'
        end

        # if variant.substrate_for_domain('astek.com')
        #   formatted += '<div>
        #     <h5>Substrate</h5>
        #     <p>Type II</p>
        #   </div>'
        # end
        # # '+variant.format_substrate_name+'
        #
        # if variant.backing_type
        #   formatted += '<div>
        #     <h5>Backing</h5>
        #     <p>'+variant.backing_type.name+'</p>
        #   </div>'
        # end

        formatted += '<div>
            <h5>Sold By</h5>
            <p>'+stock_item.sale_unit.name+'</p>
          </div>'

        design.design_properties.each do |dp|

          next if /\Aroll_length_/ =~ dp.property.name && stock_item.sale_unit.name != 'Roll'
          next if /\Aroll_width_/ =~ dp.property.name && variant.design.subcollection.subcollection_type.name == 'Roll Width'

          formatted += '<div>
            <h5>'+dp.property.presentation+'</h5>
            <p>'+format_property_value(dp)+'</p>
          </div>'

        end

        formatted += '</div>'
        formatted
      end

      def format_tearsheet_links stock_item
        out = '<!-- pdf -->'
        stock_item.variant.design.variants.each do |v|
          if v.tearsheet.file
            out += ActionController::Base.helpers.link_to('Tear Sheet', v.tearsheet.file.url, class: 'btn btn--small', target: '_blank')
          end
        end
        out
      end

      def format_property_value(dp, domain = nil)
        if matches = dp.property.name.match(/_(?<unit>inches|feet|yards|meters)\Z/)
          "#{dp.value} #{matches[:unit]}"
        elsif dp.property.name == 'margin_trim'
          format_margin_trim_property_value(dp, domain)
        else
          dp.value
        end
      end

      def format_margin_trim_property_value(dp, domain = nil)
        if domain == 'astekhome.com'
          if dp.design.digital? && (%w[Pre-trimmed Pretrimmed Untrimmed].exclude?(dp.value) || dp.value == 'Untrimmed')
            'Pre-trimmed'
          elsif %w[Pre-trimmed Pretrimmed Untrimmed].exclude?(dp.value)
            # Value for margin trim can be numeric, but we display "Untrimmed"
            'Untrimmed'
          else
            dp.value
          end
        else
          if %w[Pre-trimmed Pretrimmed Untrimmed].exclude?(dp.value)
            # Value for margin trim can be numeric, but we display "Untrimmed"
            'Untrimmed'
          else
            dp.value
          end
        end
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

      # Shopify sites require weight in grams, in whole numbers (no decimals)
      def variant_grams stock_item
        (stock_item.weight * BigDecimal('453.592', 0)).round.to_s unless stock_item.weight.nil?
      end

    end

  end
end
