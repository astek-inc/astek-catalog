module Admin
  class BaseProductDataCsvGenerator

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

    HEADER = [
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

    PRIMARY_ROW_ATTRIBUTES = %w[
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
      cost_per_item
      collection
    ]

    SECONDARY_ROW_ATTRIBUTES = ['handle', nil, nil, nil, nil, nil, nil, nil, 'option_1_value', nil, 'option_2_value', nil] +
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

    class << self

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
        formatted += format_shipping_and_returns_information design
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

        items = []

        design.design_properties.each do |dp|
          if DIMENSIONAL_PROPERTIES.include? dp.property.name

            next if design.subcollected? && design.subcollection.subcollection_type.name == 'Roll Width' && (/\Aroll_length_/ =~ dp.property.name || /\Aroll_width_/ =~ dp.property.name)
            next if /\Aroll_length_/ =~ dp.property.name && stock_item.sale_unit.name != 'Roll'
            items << '<div>
              <dt>'+dp.property.presentation+'<dt>
              <dd>'+format_property_value(dp, 'astekhome.com')+'</dd>
            </div>'

          end
        end

        out = ''

        if items.count > 0
          out = '<div class="dropdown">
            <div class="dropdown-header">
              <span>Size + Repeat</span> <span class="dropdown-caret down"></span>
            </div>

            <div class="dropdown-body">
              <dl>
                ' + items.join("\n") + '
              </dl>
            </div>
          </div>'
        end

        return out
        
      end

      def format_shipping_and_returns_information design

        if design.digital?
          body_content = '<p>This product is digitally printed to order. We do not accept returns or exchanges on digitally printed products.</p>
            <p>Digitally printed products require 1-2 weeks to print before being shipped.</p>
            <p>To learn more, visit our <a href="/pages/shipping-policy">shipping policy and returns page</a>.</p>'
        else
          body_content = '<p>Stock of this item varies. If in stock, products are shipped within 1-2 business days.</p>
            <p>This product is eligible for returns with a 30% restocking fee applied. The product must be unopened, uncut, and sent back within 30 days of purchasing.</p>
            <p>For more info, visit our <a href="/pages/shipping-policy">shipping policy and returns page</a>.</p>'
        end

        return '<div class="dropdown">
            <div class="dropdown-header">
              <span>Shipping + Returns</span> <span class="dropdown-caret down"></span>
            </div>

            <div class="dropdown-body">
              ' + body_content + '
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

    end
  end
end
