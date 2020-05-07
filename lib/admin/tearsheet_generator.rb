module Admin
  class TearsheetGenerator

    require 'open-uri'

    LOGO_IMAGE_URL = 'https://s3.amazonaws.com/astek/Logo/ASTEK_LOGO_BLACK.png'

    @variant
    
    class << self

      def generate variant

        @variant = variant

        filename = Rails.root.join('tmp', @variant.sku+'.pdf')

        logo_img = open(LOGO_IMAGE_URL)
        variant_img = open(@variant.variant_swatch_images.first.file.large.url)

        Prawn::Font::AFM.hide_m17n_warning = true

        Prawn::Document.new(margin: [20, 50]) do |pdf|

          pdf.line_width = 1.5
          pdf.image logo_img, width: 200
          pdf.draw_text 'PRODUCT', at: [210, 720]
          pdf.draw_text 'SPEC SHEET', at: [210, 705]
          pdf.move_down 12
          pdf.stroke_horizontal_rule
          pdf.move_down 12
          pdf.image variant_img, fit: [510, 300]
          pdf.move_down 12

          pdf.bounding_box([0, pdf.cursor], width: 400, height: 25) do
            pdf.stroke_color '000000'
            pdf.fill_color '000000'
            pdf.fill_and_stroke_rectangle [pdf.cursor-25, pdf.cursor], 400, 25

            pdf.fill_color 'ffffff'
            pdf.move_down 8
            pdf.indent(10) do
              pdf.text @variant.design.name.upcase + ' • ' + @variant.name.upcase + ' / ' + @variant.sku.upcase
            end
            pdf.fill_color '000000'
          end

          pdf.move_down 12
          pdf.stroke_horizontal_rule

          pdf.move_down 12
          pdf.table(
              product_info_to_columns, cell_style: { borders: [] }, column_widths: 250
          )

          pdf.stroke_horizontal_rule
          pdf.move_down 12

          pdf.font_size 9

          pdf.bounding_box([90, 130], width: 350, height: 80) do

            pdf.stroke_color '000000'
            pdf.fill_color '000000'
            pdf.fill_and_stroke_rectangle [pdf.cursor-80, pdf.cursor], 350, 90

            pdf.fill_color 'ffffff'
            pdf.move_down 15

            pdf.text 'FOB Van Nuys, CA 91406', align: :center
            pdf.text 'All wallcoverings are delivered untrimmed.', align: :center
            pdf.text 'Overlaps for double cutting are included unless otherwise requested.', align: :center
            pdf.text 'Lead times dependent on quantity ordered, as product is made to order.', align: :center
            pdf.text 'Approved strike off required prior to production.', align: :center
            pdf.text 'Contact your sales rep to initiate a strike off request.', align: :center
          end

          pdf.fill_color '000000'

          pdf.font_size 10
          pdf.bounding_box([0, 20], width: 500, height: 30) do
            pdf.text '15924 Arminta St., Van Nuys CA 91406', align: :center
            pdf.text '818.901.9876  astek.com  info@astek.com  @astekinc', align: :center
          end

          pdf.render_file filename

        end

        file = File.new(filename)
        @variant.tearsheet = file
        @variant.save!
        
      end

      def product_info_to_columns

        info = []

        if display_substrate
          info << 'MATERIAL: '+ format_substrate_name
          if display_substrate.backing_type && display_substrate.backing_type.name != 'None'
            info << 'BACKING: ' + display_substrate.backing_type.name
          end
        end

        @variant.design.design_properties.each do |dp|
          info << "#{dp.property.presentation.upcase}: #{format_property_value(dp)}"
        end

        mid = info.count / 2.ceil
        first_col = info[0..mid - 1]
        second_col = info[mid + 1..info.count - 1]

        data = []
        (0..mid).each do |i|
          data << [first_col[i], second_col[i]]
        end

        data
      end

      def format_substrate_name

        name = display_substrate.name

        category_names = display_substrate.substrate_categories.map { |c| c.name }
        paren_items = []

        if category_names.include? 'Type II'
          paren_items << 'Type II'
        end

        # if category_names.include? 'Vinyl'
        #   paren_items << 'Commercial Vinyl'
        # end

        if paren_items.any?
          name += ' (' + paren_items.join(' ') + ')'
        end

        name

      end

      # On astek.com, we don't print on paper
      def display_substrate
        if @variant.substrate.name == 'Paper'
          Substrate.find_by(name: 'Matte Vinyl')
        else
          @variant.substrate
        end
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
