class Variant < ActiveRecord::Base

  require 'open-uri'

  resourcify

  include RankedModel
  ranks :row_order, with_same: :design_id

  acts_as_paranoid

  mount_uploader :tearsheet, TearsheetUploader

  belongs_to :design
  belongs_to :variant_type
  belongs_to :substrate
  belongs_to :backing_type

  has_many :variant_swatch_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy
  has_many :variant_install_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy

  has_and_belongs_to_many :product_types
  has_and_belongs_to_many :colors

  validates :variant_type_id, presence: true
  validates :name, presence: true
  validates :sku, presence: true

  # def has_color? find_color
  #   self.colors.include? find_color
  # end

  scope :with_color, ->(color_name) { joins(:colors).where('colors.name = ?', color_name) }

  def title
    self.design.name
  end

  def option_3_value
    if self.substrate
      self.substrate.name
    elsif self.backing_type
      self.backing_type.name
    end
  end

  # Sites require weight in grams, in whole numbers (no decimals)
  def variant_grams
    (self.design.weight * BigDecimal('453.592')).round.to_s
  end

  def published?
    self.design.available_on < Time.now && ( self.design.expires_on.nil? || self.design.expires_on > Time.now ) && self.design.deleted_at.nil?
  end

  def body
    body = self.description
    if self.tearsheet.file
      body += $/ + ActionController::Base.helpers.link_to('Spec Sheet', self.tearsheet.file.url, class: 'btn')
    end
    body
  end

  def description
    self.design.description
  end

  def vendor
    self.design.collection.vendor.name
  end

  def type
    self.design.collection.product_category.name
  end

  def swatch_image_url position
    if self.variant_swatch_images
      self.variant_swatch_images[position].file.url
    end
  end

  def price
    self.design.price.to_s
  end

  # For export to Shopify websites
  def sku_with_colors
    self.sku + '__' + self.colors.map { |c| c.name.gsub(/\s+/, '-').downcase }.join('__')
  end

  def generate_tearsheet
    filename = Rails.root.join('tmp', self.sku+'.pdf')

    logo_img = open('https://s3.amazonaws.com/astek/Logo/ASTEK_LOGO_BLACK.png')
    variant_img = open(self.variant_swatch_images.first.file.large.url)

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
          pdf.text self.design.name.upcase + ' • ' + self.name.upcase + ' / ' + self.sku.upcase
        end
        pdf.fill_color '000000'
      end

      pdf.move_down 12
      pdf.stroke_horizontal_rule

      pdf.move_down 12
      pdf.table(
          self.product_info_to_columns, cell_style: { borders: [] }, column_widths: 250
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
    self.tearsheet = file
    self.save!
  end

  def product_info_to_columns

    info = []
    if self.substrate
      info << 'MATERIAL: '+self.format_substrate_name
    end

    self.design.design_properties.each do |dp|
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

    name = self.substrate.name

    category_names = self.substrate.substrate_categories.map { |c| c.name }
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
