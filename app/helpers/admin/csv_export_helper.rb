module Admin
  module CsvExportHelper

    require 'csv'

    MATERIALS = [
        { name: 'Paper', surcharge: '0' },
        { name: 'Type II Commercial Vinyl', surcharge: '0.50' },
        { name: 'Peel & Stick Wall Tiles', surcharge: '1.50' },
        { name: 'Gold Mylar', surcharge: '1.00' },
        { name: 'Silver Mylar', surcharge: '1.00' },
    ]

    TEXT_VALUES = {
        option_1_name: 'Color',
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

    def variants_to_csv design, website, include_header=true
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
          name
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
        ] + 17.times.map { nil } + ['variant_image'] + 3.times.map { nil }

      CSV.generate(headers: true) do |csv|

        if include_header
          csv << header
        end

        total_image_count = design.design_images.count + design.variants.count
        @custom_image_index = total_image_count
        # puts 'custom image index: '+@custom_image_index.to_s

        @first_row = true
        design.variants.each_with_index do |variant, i|
          @image_index = i
          first_variant_row = true

          if website == 'astekhome.com' && design.collection.user_can_select_material
            MATERIALS.each do |material|
              if @first_row
                csv << primary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'full', @image_index, website, material[:name], first_variant_row)) }
                @first_row = false
              else
                csv << secondary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'full', @image_index, website, material[:name], first_variant_row)) }
              end

              csv << secondary_row_attributes.map { |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'sample', 0, website, material[:name])) }
              first_variant_row = false
            end
          else
            if @first_row
              csv << primary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'full', @image_index, website)) }
              @first_row = false
            else
              csv << secondary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'full', @image_index, website)) }
            end

            if website == 'astekhome.com'
              csv << secondary_row_attributes.map { |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'sample', 0, website)) }
            end
          end
        end

        if website == 'astekhome.com'
          if design.collection.user_can_select_material
            first_custom_row = true
            MATERIALS.each do |material|
              csv << secondary_row_attributes.map { |attr| (attr.nil? ? nil : attribute_value(attr, design.variants.first, 'custom', @custom_image_index, website, material[:name], first_custom_row)) }
              csv << secondary_row_attributes.map { |attr| (attr.nil? ? nil : attribute_value(attr, design.variants.first, 'custom_sample', 0, website, material[:name], first_custom_row)) }
              first_custom_row = false
            end
          elsif design.digital?
            csv << secondary_row_attributes.map { |attr| (attr.nil? ? nil : attribute_value(attr, design.variants.first, 'custom', @custom_image_index, website)) }
            csv << secondary_row_attributes.map { |attr| (attr.nil? ? nil : attribute_value(attr, design.variants.first, 'custom_sample', 0, website)) }
          end
        end

        if design.design_images
          design.design_images.each do |image|
            @image_index += 1
            csv << ['D-'+design.sku] + 23.times.map { nil } + [image.file.url, @image_index + 1] + 21.times.map { nil }

          end
        end
      end

    end

    def attribute_value attr, variant, variant_type, image_index, domain, material=nil, show_image=true

      if TEXT_VALUES[attr.to_sym]

        TEXT_VALUES[attr.to_sym]

      elsif attr == 'handle'
        'D-'+variant.design.sku

      elsif attr == 'body'
        # if variant_type == 'full'
          case domain
          when 'astek.com'
            astek_business_description variant
          when 'astekhome.com'
            # if variant_type == 'full'
              astek_home_description variant
            # end
          end
        # end

      elsif attr == 'tags'
        if variant_type == 'full'
          variant.design.tags domain
        end

      elsif attr == 'option_1_value'
        case variant_type
        when 'custom', 'custom_sample'
          'Custom'
        else
          variant.name
        end

      elsif attr == 'image_src'
        if show_image
          case variant_type
          when 'full'
              variant.image_url 0
          when 'custom'
              'https://s3-us-west-2.amazonaws.com/astek-home/site-files/Product-Custom-Colorway-Swatch.png'
          else
            nil
          end
        else
          nil
        end

      elsif attr == 'image_alt_text'
        if variant.design.digital?
          'Digital wallcovering image'
        else
          'In-stock wallcovering image'
        end

      elsif attr == 'image_position'
        case variant_type
        when 'sample', 'custom_sample'
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
          'Size'
        end

      elsif attr == 'option_2_value'
        case domain
        when 'astek.com'
          nil
        when 'astekhome.com'
          case variant_type
          when 'sample', 'full'
            variant_type.capitalize
          when 'custom_sample'
            'Sample'
          else
            'Full'
          end
        end

      elsif attr == 'option_3_name'
        case domain
        when 'astek.com'
          nil
        when 'astekhome.com'
          'Material'
        end

      elsif attr == 'option_3_value'
        case domain
        when 'astek.com'
          nil
        when 'astekhome.com'
          material
        end

      elsif attr == 'sku'

        case variant_type
        when 'sample'
          variant.sku+'-s'
        when 'custom'
          variant.design.sku+'-c'
        when 'custom_sample'
          variant.design.sku+'-c-s'
        when 'full'
          variant.sku_with_colors
        end

      elsif attr == 'variant_grams'
        case domain
        when 'astek.com'
          nil
        when 'astekhome.com'
          if variant_type == 'sample' || variant_type == 'custom_sample'
            (BigDecimal('.01') * BigDecimal('453.592')).round.to_s
          else
            variant.variant_grams
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
          nil
        when 'astekhome.com'
          if variant_type == 'sample' || variant_type == 'custom_sample'
            if variant.design.digital?
              10.99.to_s
            else
              5.99.to_s
            end
          else
            variant.price
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
        if show_image
          case variant_type
          when 'full'
            variant.image_url 0
          else
            nil
          end
        else
          nil
        end

      elsif attr == 'collection'
        case domain
        when 'astek.com'
          unless variant.design.collection.suppress_from_display
            variant.design.collection.name
          end
        when 'astekhome.com'
          nil
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

    def astek_business_description variant
      body = ''

      if variant.description
        body += format_description variant
      end

      body += format_business_properties variant

      if variant.tearsheet.file
        body += format_tearsheet_link variant
      end

      body
    end

    def astek_home_description variant
      body = ''

      if variant.description
        body += format_description variant
      end

      body += format_home_properties variant
      
      body
    end

    def format_description variant
      '<div>
          <p>'+variant.description+'</p>
      </div>'
    end

    def format_business_properties variant
      formatted = '<div class="description__formatted">'
      variant.design.design_properties.each do |dp|
        formatted += $/ + '<div>
          <h5>'+dp.property.presentation+'</h5>
          <p>'+dp.value+'</p>
        </div>'
      end

      formatted += $/ + '</div>'
      formatted
    end

    def format_home_properties variant
      formatted = '<div class="description__formatted">'
      variant.design.design_properties.each do |dp|
        formatted += $/ + '<div>
          <h6>'+dp.property.presentation+'</h6>
          <p>'+dp.value+'</p>
        </div>'
      end

      if variant.design.minimum_quantity > 1
        formatted += $/ + '<div>
          <h6>Minimum quantity</h6>
          <p>'+variant.design.minimum_quantity.to_s+'</p>
        </div>'
      end

      if variant.design.sale_quantity > 1
        formatted += $/ + '<div>
          <h6>Sold in quantities of</h6>
          <p>'+variant.design.sale_quantity.to_s+'</p>
        </div>'
      end

      formatted += $/ + '</div>'
      formatted
    end

    def format_tearsheet_link variant
      '<!-- pdf -->' + $/ + ActionController::Base.helpers.link_to('Tear Sheet', variant.tearsheet.file.url, class: 'btn btn--small', target: '_blank')
    end

  end
end
