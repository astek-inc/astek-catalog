module Admin
  module ProductDataCsvGenerator

    require 'csv'

    SAMPLE_WEIGHT = '.5'
    SAMPLE_PRICE_DIGITAL = '10.99'
    SAMPLE_PRICE_DISTRIBUTED = '5.99'

    TEXT_VALUES = {
        variant_barcode: '',
        variant_inventory_tracker: '',
        variant_inventory_policy: 'Continue',
        variant_fulfillment_service: 'Manual',
        variant_compare_at_price: '',
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
        variant_tax_code: ''
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
            description
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
          ] + 16.times.map { nil } + ['variant_image', 'variant_weight_unit'] + 2.times.map { nil }

        CSV.generate(headers: true) do |csv|

          if include_header
            csv << header
          end

          total_image_count = design.variants.count + design.variants.select { |v| v.variant_install_images.any? }.count

          @custom_image_index = total_image_count
          # puts 'custom image index: '+@custom_image_index.to_s

          @first_row = true

          # On astekhome.com, if a design has colorways, we don't show the install images separately.
          # Instead, we mix a random install image in with the swatch images
          @random_install_image = nil
          if website == 'astekhome.com' && design.has_colorways?
            if install_images = design.install_images
              @random_install_image = install_images.sample
            end
          end

          design.variants.each_with_index do |variant, i|
            @image_index = i
            first_variant_row = true

            if website == 'astekhome.com' && design.user_can_select_material

              design.custom_materials.joins(:substrate).order('default_material DESC, COALESCE(substrates.display_name, substrates.name) ASC').each do |material|

                if @first_row
                  csv << primary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'full', @image_index, website, material, first_variant_row)) }
                  @first_row = false
                else
                  csv << secondary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'full', @image_index, website, material, first_variant_row)) }
                end
                first_variant_row = false

                unless design.collection.suppress_sample_option_from_display
                  csv << secondary_row_attributes.map { |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'sample', 0, website, material)) }
                end

              end

            else
              if @first_row
                csv << primary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'full', @image_index, website)) }
                @first_row = false
              else
                csv << secondary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'full', @image_index, website)) }
              end

              if website == 'astekhome.com'
                unless design.collection.suppress_sample_option_from_display
                  csv << secondary_row_attributes.map { |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'sample', 0, website)) }
                end
              end
            end
          end

          # On astekhome.com, if a design has colorways, we don't show the install images separately, we mix a random install image in with the swatch images
          if website == 'astek.com' || (website == 'astekhome.com' && !design.has_colorways?)
            design.variants.each do |variant|
              if variant.variant_install_images
                variant.variant_install_images.each do |image|
                  @image_index += 1
                  csv << ['D-'+design.sku] + 23.times.map { nil } + [image.file.url, @image_index + 1] + 21.times.map { nil }

                end
              end
            end
          end
        end

      end

      def attribute_value attr, variant, variant_type, image_index, domain, material=nil, show_image=true

        if TEXT_VALUES[attr.to_sym]

          TEXT_VALUES[attr.to_sym]

        elsif attr == 'handle'
          # Add a prefix to ensure that this is distinct from any variant SKU
          'D-'+variant.design.sku

        elsif attr == 'body'
          case domain
          when 'astek.com'
            astek_business_description variant
          when 'astekhome.com'
            astek_home_description variant
          end

        elsif attr == 'tags'
          if variant_type == 'full'
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
            if variant.variant_type.name == 'Color Way' || variant.design.digital?
              'Size'
            else
              if variant.design.user_can_select_material
                'Material'
              end
            end
          end

        elsif attr == 'option_2_value'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            if variant.variant_type.name == 'Color Way' || variant.design.digital?
              astek_home_size_value variant_type
            else
              astek_home_material_value material
            end
          end

        elsif attr == 'option_3_name'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            if (variant.variant_type.name == 'Color Way' || variant.design.digital?) && variant.design.user_can_select_material
              'Material'
            end
          end

        elsif attr == 'option_3_value'
          case domain
          when 'astek.com'
            nil
          when 'astekhome.com'
            if (variant.variant_type.name == 'Color Way' || variant.design.digital?) && variant.design.user_can_select_material
              astek_home_material_value material
            end
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
              (BigDecimal(SAMPLE_WEIGHT) * BigDecimal('453.592')).round.to_s
            else
              if material
                (BigDecimal(material.substrate.weight_per_square_foot) * BigDecimal('453.592')).round.to_s
              elsif variant.design.digital?
                (BigDecimal(variant.substrate.weight_per_square_foot) * BigDecimal('453.592')).round.to_s
              else
                variant.variant_grams
              end
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
              if variant.design.digital?
                SAMPLE_PRICE_DIGITAL
              else
                SAMPLE_PRICE_DISTRIBUTED
              end
            else
              if material
                (BigDecimal(variant.price) + BigDecimal(material.surcharge)).to_s
              else
                variant.price
              end
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

      def astek_business_description variant
        body = ''

        if variant.design.description
          body += format_description variant
        end

        body += format_business_properties variant

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

      def format_description variant
        '<div>
            <p>'+variant.design.description+'</p>
        </div>'
      end

      def format_business_properties variant
        formatted = '<div class="description__meta">'

        unless variant.design.collection.suppress_from_display
          formatted += '<div>
              <h5>Collection</h5>
              <p><a href="/collections/'+variant.design.collection.name.parameterize+'">'+variant.design.collection.name+'</a></p>
            </div>'
        end

        if variant.substrate
          formatted += '<div>
            <h5>Substrate</h5>
            <p>Type II</p>
          </div>'
        end
        # '+variant.format_substrate_name+'

        if variant.backing_type
          formatted += '<div>
            <h5>Backing</h5>
            <p>'+variant.backing_type.name+'</p>
          </div>'
        end

        formatted += '<div>
            <h5>Sold By</h5>
            <p>'+variant.design.sale_unit.name+'</p>
          </div>'

        variant.design.design_properties.each do |dp|
          next if /\Aroll_length_/ =~ dp.property.name && variant.design.sale_unit.name != 'Roll'
          formatted += '<div>
            <h5>'+dp.property.presentation+'</h5>
            <p>'+format_property_value(dp)+'</p>
          </div>'
        end

        formatted += '</div>'
        formatted
      end

      def format_home_properties variant
        formatted = '<div class="description__meta">'

        formatted += '<div>
              <h6>SKU</h6>
              <p>'+variant.design.sku+'</p>
            </div>'

        unless variant.design.collection.suppress_from_display
          formatted += '<div>
              <h6>Collection</h6>
              <p><a href="/collections/'+variant.design.collection.name.parameterize+'">'+variant.design.collection.name+'</a></p>
            </div>'
        end

        if variant.design.collection.lead_time
          formatted += '<div>
              <h6>Lead Time</h6>
              <p>'+variant.design.collection.lead_time.name+'</p>
            </div>'
        end

        variant.design.design_properties.each do |dp|
          next if /\Aroll_length_/ =~ dp.property.name && variant.design.sale_unit.name != 'Roll'
          formatted += '<div>
            <h6>'+dp.property.presentation+'</h6>
            <p>'+format_property_value(dp)+'</p>
          </div>'
        end

        if variant.design.minimum_quantity > 1
          formatted += '<div>
            <h6>Minimum quantity</h6>
            <p>'+variant.design.minimum_quantity.to_s+' '+variant.design.sale_unit.name.pluralize.titleize+'</p>
          </div>'
        end

        if variant.design.sale_quantity > 1
          formatted += '<div>
            <h6>Sold in quantities of</h6>
            <p>'+variant.design.sale_quantity.to_s+'</p>
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

      def format_property_value dp
        if matches = dp.property.name.match(/_(?<unit>inches|yards|meters)\Z/)
          "#{dp.value} #{matches[:unit]}"
        elsif dp.property.name == 'margin_trim' && !%w[Pre-trimmed Untrimmed].include?(dp.value)
          # Value for margin trim can be numeric, but we display "Untrimmed"
          'Untrimmed'
        else
          dp.value
        end
      end

    end

  end
end
