module Admin
  module ProductDataCsvGenerator

    require 'csv'

    SAMPLE_WEIGHT = '.5'
    SAMPLE_PRICE_DIGITAL = '10.99'
    SAMPLE_PRICE_DISTRIBUTED = '5.99'

    DIMENSIONAL_PROPERTIES = %w[
      motif_width_inches
      mural_height_inches
      mural_width_inches
      panel_height_inches
      panels_per_set
      panel_width_inches
      printed_width_inches
      repeat_match_type
      roll_length_feet
      roll_length_meters
      roll_length_yards
      roll_width_inches
      tile_height_inches
      tile_width_inches
      vertical_repeat_inches
    ]

    TEXT_VALUES = {
        variant_barcode: '',
        variant_inventory_tracker: '',
        variant_inventory_policy: 'Continue',
        variant_fulfillment_service: 'Manual',
        # variant_compare_at_price: '',
        google_shopping_mpn: '',
        google_shopping_age_group: '',
        google_shopping_gender: '',
        google_shopping_google_product_category: '',
        google_shopping_adwords_grouping: '',
        google_shopping_adwords_labels: '',
        google_shopping_condition: '',
        google_shopping_custom_product: '',
        google_shopping_custom_label_0: '',
        google_shopping_custom_label_1: '',
        google_shopping_custom_label_2: '',
        google_shopping_custom_label_3: '',
        google_shopping_custom_label_4: '',
        variant_tax_code: '',
        cost_per_item: ''
    }

    class << self

      def product_data_csv design, website, include_header=true
        header = [
            'Handle',
            'Title',
            'Body (HTML)',
            'Vendor',
            'Type',
            'Tags',
            'Published',
            'Option1 Name',
            'Option1 Value',
            'Option2 Name',
            'Option2 Value',
            'Option3 Name',
            'Option3 Value',
            'Variant SKU',
            'Variant Grams',
            'Variant Inventory Tracker',
            'Variant Inventory Qty',
            'Variant Inventory Policy',
            'Variant Fulfillment Service',
            'Variant Price',
            'Variant Compare At Price',
            'Variant Requires Shipping',
            'Variant Taxable',
            'Variant Barcode',
            'Image Src',
            'Image Position',
            'Image Alt Text',
            'Gift Card',
            'Google Shopping / MPN',
            'Google Shopping / Age Group',
            'Google Shopping / Gender',
            'Google Shopping / Google Product Category',
            'SEO Title',
            'SEO Description',
            'Google Shopping / AdWords Grouping',
            'Google Shopping / AdWords Labels',
            'Google Shopping / Condition',
            'Google Shopping / Custom Product',
            'Google Shopping / Custom Label 0',
            'Google Shopping / Custom Label 1',
            'Google Shopping / Custom Label 2',
            'Google Shopping / Custom Label 3',
            'Google Shopping / Custom Label 4',
            'Variant Image',
            'Variant Weight Unit',
            'Variant Tax Code',
            'Cost Per Item',
            'Collection'
        ]

        primary_row_attributes = %w[
            handle
            title
            body
            vendor
            type
            tags
            published?
            option_1_name
            option_1_value
            option_2_name
            option_2_value
            option_3_name
            option_3_value
            sku
            variant_grams
            variant_inventory_tracker
            variant_inventory_qty
            variant_inventory_policy
            variant_fulfillment_service
            price
            variant_compare_at_price
            variant_requires_shipping
            variant_taxable
            variant_barcode
            image_src
            image_position
            image_alt_text
            gift_card
            google_shopping_mpn
            google_shopping_age_group
            google_shopping_gender
            google_shopping_google_product_category
            seo_title
            seo_description
            google_shopping_adwords_grouping
            google_shopping_adwords_labels
            google_shopping_condition
            google_shopping_custom_product
            google_shopping_custom_label_0
            google_shopping_custom_label_1
            google_shopping_custom_label_2
            google_shopping_custom_label_3
            google_shopping_custom_label_4
            variant_image
            variant_weight_unit
            variant_tax_code
            cost_per_item
            collection
        ]

        secondary_row_attributes = ['handle', nil, nil, nil, nil, nil, nil, nil, 'option_1_value', nil, 'option_2_value', nil] +
            %w[
            option_3_value
            sku
            variant_grams
            variant_inventory_tracker
            variant_inventory_qty
            variant_inventory_policy
            variant_fulfillment_service
            price
            variant_compare_at_price
            variant_requires_shipping
            variant_taxable
            variant_barcode
            image_src
            image_position
            image_alt_text
          ] + 16.times.map { nil } + ['variant_image', 'variant_weight_unit'] + 3.times.map { nil }

        CSV.generate(headers: true) do |csv|

          if include_header
            csv << header
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
                csv << primary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, stock_item, full_variant_type, @image_index, website, nil, first_variant_row, substrate)) }
                @first_row = false
              else
                csv << secondary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, stock_item, full_variant_type, @image_index, website, nil, first_variant_row, substrate)) }
              end
              first_variant_row = false

              if website == 'astekhome.com'
                murals = ProductType.find_by(name: 'Murals')
                unless design.collection.suppress_sample_option_from_display || (design.distributed? && variant.product_types.include?(murals))
                  csv << secondary_row_attributes.map { |attr| (attr.nil? ? nil : attribute_value(attr, stock_item, sample_variant_type, 0, website, nil, nil, substrate)) }
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

        if TEXT_VALUES[attr.to_sym]

          TEXT_VALUES[attr.to_sym]

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
              (BigDecimal(SAMPLE_WEIGHT, 0) * BigDecimal('453.592', 0)).round.to_s
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
                SAMPLE_PRICE_DIGITAL
              else
                SAMPLE_PRICE_DISTRIBUTED
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

      def astek_home_colorway_value variant_type, variant_name
        case variant_type
        when 'custom', 'custom_sample'
          'Custom'
        else
          variant_name
        end
      end

      def astek_home_size_value variant_type
        if /\A(?<label>sample|full)/ =~ variant_type
          label.capitalize
        elsif variant_type == 'custom_sample'
          'Sample'
        else
          'Full'
        end
      end

      # def astek_home_custom_material_value custom_material
      #   if custom_material
      #     custom_material.name
      #   end
      # end

      def body_for_domain stock_item, domain
        case domain
        when 'astek.com'
          astek_business_description stock_item, domain
        when 'astekhome.com'
          astek_home_description stock_item
        when 'onairdesign.com'
          onair_design_description stock_item, domain
        end
      end

      def astek_business_description stock_item, domain

        variant = stock_item.variant

        body = ''

        if formatted_description = format_description(stock_item, domain)
          body += formatted_description
        end

        body += format_business_properties(stock_item, domain)

        if variant.tearsheet.file
          body += format_tearsheet_links variant
        end

        body = body.gsub(/\n+/, ' ')
        body
      end

      def astek_home_description stock_item
        body = format_home_properties(stock_item).gsub(/\n+/, ' ')
        body
      end

      def onair_design_description(stock_item, domain)
        body = ''
        if formatted_description = format_description(stock_item, domain)
          body += formatted_description
        end
        body += format_onair_properties(variant)
        body = body.gsub(/\n+/, ' ')
        body
      end

      def format_description(stock_item, domain)

        variant = stock_item.variant

        formatted_description = ''

        if description = variant.design.description_for_domain(domain)
          formatted_description += '<p>' + description + '</p>'
        end

        if domain == 'astek.com' && variant.design.collection.product_category.name == 'Contract Vinyl'
          formatted_description += '<p>For digitally printed commercial grade vinyl wallcoverings, visit our <a href="/collections/studio">Studio</a> collections.</p>'
        end

        unless formatted_description.blank?
          "<div>
            #{formatted_description}
          </div>"
        end

      end

      def format_business_properties(stock_item, domain)

        variant = stock_item.variant
        design = variant.design

        formatted = '<div class="description__meta">'

        unless design.collection.suppress_from_display
          formatted += '<div>
              <h5>Collection</h5>
              <p><a href="/collections/' + design.collection.name.gsub("\'", "").parameterize + '">' + design.collection.name + '</a></p>
            </div>'
        end

        if design.digital?
          # This property has to apply to all variants, so we are making sure that they are all Type II.
          sis = design.variants.map { |v| v.stock_items.for_domain(domain) }.flatten!
          if sis.select { |si| si.substrate.substrate_categories.map { |sc| sc.name }.include? 'Type II' }.count == sis.count
            formatted += '<div>
              <h5>Substrate</h5>
              <p>Type II</p>
            </div>'
          end
        end

        unless design.digital?
          if stock_item.backing_type
            formatted += '<div>
              <h5>Backing</h5>
              <p>' + stock_item.backing_type.name + '</p>
            </div>'
            # elsif variant_substrate && variant_substrate.backing_type
            #   formatted += '<div>
            #     <h5>Backing</h5>
            #     <p>'+variant_substrate.backing_type.name+'</p>
            #   </div>'
          end
        end

        if stock_item.sale_unit.present?
          formatted += '<div>
              <h5>Sold By</h5>
              <p>' + stock_item.sale_unit.name + '</p>
            </div>'
        end

        if stock_item.price_code.present?
          formatted += '<div>
            <h5>Price Code</h5>
            <p>' + stock_item.price_code + '</p>
          </div>'
        end

        design.design_properties.each do |dp|
          next if /\Aroll_length_/ =~ dp.property.name && stock_item.sale_unit.name != 'Roll'
          formatted += '<div>
            <h5>' + dp.property.presentation + '</h5>
            <p>' + format_property_value(dp) + '</p>
          </div>'
        end

        formatted += '</div>'
        formatted
      end

      def format_home_properties stock_item

        variant = stock_item.variant
        design = variant.design

        formatted = '<!-- DESCRIPTION V2 -->
        <div class="description__meta">'

        formatted += format_dimensional_properties design, stock_item
        formatted += format_shipping_and_returns_information
        formatted += format_additional_specs design, stock_item

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

      def format_dimensional_properties design, stock_item

        items = ''

        design.design_properties.each do |dp|
          if DIMENSIONAL_PROPERTIES.include? dp.property.name

            next if /\Aroll_length_/ =~ dp.property.name && stock_item.sale_unit.name != 'Roll'
            items += '<div>
              <dt>'+dp.property.presentation+'<dt>
              <dd>'+format_property_value(dp, 'astekhome.com')+'</dd>
            </div>'

          end
        end

        return '<div class="dropdown">
          <div class="dropdown-header">
            <span>Size + Repeat</span> <span class="dropdown-caret down"></span>
          </div>

          <div class="dropdown-body">
            <dl>
              ' + items + '
            </dl>
          </div>
        </div>'

      end

      def format_shipping_and_returns_information

        return '<div class="dropdown">
          <div class="dropdown-header">
            <span>Shipping + Returns</span> <span class="dropdown-caret down"></span>
          </div>

          <div class="dropdown-body">
            <p>This product is digitally printed to order. We do not accept returns or exchanges on digitally printed products.</p>
            <p>Print to order products require at least 7 days to print before being shipped.</p>
            <p>To learn more visit our <a href="/pages/shipping-policy">shipping policy and returns page</a>.</p>
          </div>
        </div>'

      end

      def format_additional_specs design, stock_item

        items = ''

        items += '<div>
          <dt>SKU</dt>
          <dd>'+design.sku+'</dd>
        </div>'

        unless design.collection.suppress_from_display
          items += '<div>
            <dt>Collection</dt>
            <dd><a href="/collections/'+design.collection.name.parameterize+'">'+design.collection.name+'</a></dd>
          </div>'
        end

        if design.collection.lead_time
          items += '<div>
            <dt>Lead time</dt>
            <dd>'+design.collection.lead_time.name+'</dd>
          </div>'
        end

        design.design_properties.each do |dp|
          if DIMENSIONAL_PROPERTIES.exclude? dp.property.name
            items += '<div>
              <dt>'+dp.property.presentation+'</dt>
              <dd>'+format_property_value(dp, 'astekhome.com')+'</dd>
            </div>'
          end
        end

        if stock_item.minimum_quantity > 1
          items += '<div>
            <dt>Minimum quantity</dt>
            <dd>'+stock_item.minimum_quantity.to_s+' '+stock_item.sale_unit.name.pluralize.titleize+'</dd>
          </div>'
        end

        if stock_item.sale_quantity > 1
          items += '<div>
            <dt>Sold in quantities of</dt>
            <dd>'+stock_item.sale_quantity.to_s+'</dd>
          </div>'
        end

        return '<div class="dropdown">
          <div class="dropdown-header">
            <span>Additional Specs</span> <span class="dropdown-caret down"></span>
          </div>

          <div class="dropdown-body">
            <dl>
              ' + items + '
            </dl>
          </div>
        </div>'

      end

      def format_onair_properties stock_item

        variant = stock_item.variant
        design = variant.design

        formatted = '<div class="description__meta">'

        formatted += '<div>
              <h5>SKU</h5>
              <p>'+design.sku+'</p>
            </div>'

        unless design.collection.suppress_from_display
          formatted += '<div>
              <h5>Collection</h5>
              <p><a href="/collections/'+design.collection.name.parameterize+'">'+design.collection.name+'</a></p>
            </div>'
        end

        formatted += '<div>
            <h5>Sold By</h5>
            <p>'+stock_item.sale_unit.name+'</p>
          </div>'

        design.design_properties.each do |dp|
          next unless %w[
            margin_trim
            motif_width_inches
            mural_height_inches
            mural_width_inches
            panel_height_inches
            panel_width_inches
            panels_per_set
            printed_width_inches
            repeat_match_type
            roll_length_meters
            roll_length_yards
            roll_width_inches
            tile_height_inches
            tile_width_inches
            vertical_repeat_inches
          ].include? dp.property.name

          next if /\Aroll_length_/ =~ dp.property.name && stock_item.sale_unit.name != 'Roll'

          formatted += '<div>
            <h5>'+dp.property.presentation+'</h5>
            <p>'+format_property_value(dp)+'</p>
          </div>'
        end

        formatted += '</div>'
        formatted
      end

      def format_tearsheet_links variant
        out = '<!-- pdf -->'
        variant.design.variants.each do |v|
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

      # If the printed width of a given design is less than standard, more physical material
      # may be required to complete a given order, so the weight of a square foot of a variant
      # is given as more than standard. We want to apply the same increase to the custom material
      # options
      def custom_material_stock_item_weight custom_material, stock_item
        substrate = stock_item.substrate
        if BigDecimal(stock_item.weight, 0) == BigDecimal(substrate.weight_per_square_foot, 0)
          (BigDecimal(custom_material.substrate.weight_per_square_foot, 0) * BigDecimal('453.592', 0)).round.to_s
        else
          ratio = BigDecimal(stock_item.weight, 0) / BigDecimal(substrate.weight_per_square_foot, 0)
          (BigDecimal(custom_material.substrate.weight_per_square_foot, 0) * ratio * BigDecimal('453.592', 0)).round.to_s
        end
      end

      # Shopify sites require weight in grams, in whole numbers (no decimals)
      def variant_grams stock_item
        (stock_item.weight * BigDecimal('453.592', 0)).round.to_s unless stock_item.weight.nil?
      end

    end

  end
end
