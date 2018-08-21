module Admin
  module VariantHelper

    require 'csv'

    TEXT_VALUES = {
        option_1_name: 'Color',
        option_2_name: 'Size',
        option_3_name: 'Material',
        variant_requires_shipping: 'TRUE',
        variant_taxable: 'TRUE',
        variant_barcode: '',
        variant_inventory_tracker: '',
        variant_inventory_qty: 1,
        variant_inventory_policy: 'Continue',
        variant_fulfillment_service: 'Manual',
        variant_compare_at_price: '',
        image_src: '',
        image_position: '',
        image_alt_text: '',
        gift_card: 'FALSE',
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
        variant_weight_unit: 'lb',
        variant_tax_code: ''
    }

    def variants_to_csv variants, website, include_header=true
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
          name
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
          image_url
          variant_weight_unit
          variant_tax_code
          collection
      ]
      secondary_row_attributes = 43.times.map { nil } + %w(image_url) + 3.times.map { nil }
      
      CSV.generate(headers: true) do |csv|

        if include_header
          csv << header
        end

        variants.each do |variant|

          csv << primary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'full', 0, website)) }

          if variant.variant_images.count > 1
            (1..variant.variant_images.count - 1).each do | image_index |
              csv << secondary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'full', image_index, website)) }
            end
          end

          csv << primary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'sample', 0, website)) }

          if variant.design.product_type.product_category.name == 'Digital'
            csv << primary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 'custom', 0, website)) }
          end

        end
      end

    end

    def attribute_value attr, variant, variant_type, image_index, domain

      if TEXT_VALUES[attr.to_sym]
        TEXT_VALUES[attr.to_sym]
      elsif attr == 'body'

        case domain
        when 'astek.com'
          astek_business_description variant
        when 'astekhome.com'
          astek_home_description variant
        else
          astek_business_description variant
        end

      elsif attr == 'option_2_value'

        case variant_type
        when 'sample', 'full'
          variant_type.capitalize
        else
          'Full'
        end

      elsif attr == 'sku'

        case variant_type
        when 'sample'
          variant.sku+'-s'
        when 'custom'
          variant.sku+'-c'
        else
          variant.sku
        end

      elsif attr == 'collection'

        case domain
        when 'astek.com'
          variant.collection
        when 'astekhome.com'
          nil
        end

      elsif attr == 'image_url'
        variant.image_url image_index.to_i
        
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

      body += format_properties variant

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

      body += format_properties variant
      
      body
    end

    def format_description variant
      '<div>
          <p>'+variant.description+'</p>
      </div>'
    end

    def format_properties variant
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

    def format_tearsheet_link variant
      '<!-- pdf -->' + $/ + ActionController::Base.helpers.link_to('Tear Sheet', variant.tearsheet.file.url, class: 'btn btn--small')
    end

  end
end
