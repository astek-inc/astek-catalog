module Admin
  module VariantHelper

    require 'csv'

    TEXT_VALUES = {
        option_1_name: 'Title',
        option_2_name: '',
        option_2_value: '',
        option_3_name: '',
        option_3_value: '',
        variant_grams: 14.5,
        variant_requires_shipping: 'TRUE',
        variant_taxable: 'TRUE',
        variant_barcode: '',
        variant_inventory_tracker: '',
        variant_inventory_qty: 1,
        variant_inventory_policy: 'continue',
        variant_fulfillment_service: 'manual',
        variant_compare_at_price: 999.99,
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
        variant_image: '',
        variant_weight_unit: 'lb',
        variant_tax_code: ''
    }

    def variants_to_csv variants
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
          sku
          name
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
          image_url
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
      secondary_row_attributes = 24.times.map { nil } + %w(image_url image_position image_alt_text) + 20.times.map { nil }
      
      CSV.generate(headers: true) do |csv|
        csv << header

        variants.each do |variant|

          csv << primary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, 0)) }

          if variant.variant_images.count > 1

            (1..variant.variant_images.count - 1).each do | image_index |
              csv << secondary_row_attributes.map{ |attr| (attr.nil? ? nil : attribute_value(attr, variant, image_index)) }
            end
          end

        end
      end

    end

    def attribute_value attr, variant, image_index
      if TEXT_VALUES[attr.to_sym]
        TEXT_VALUES[attr.to_sym]
      elsif attr == 'image_position'
        image_index + 1
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

  end
end
