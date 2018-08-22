class Variant < ActiveRecord::Base

  require 'open-uri'

  resourcify

  extend FriendlyId
  friendly_id :name, use: :slugged

  include RankedModel
  ranks :row_order, with_same: :design_id

  acts_as_paranoid

  mount_uploader :tearsheet, TearsheetUploader

  belongs_to :design
  belongs_to :variant_type
  belongs_to :substrate

  has_many :variant_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy

  has_and_belongs_to_many :colors
  has_and_belongs_to_many :substrates

  validates :variant_type_id, presence: true
  validates :name, presence: true
  validates :sku, presence: true
  validates :slug, presence: true, on: :update

  def has_color? color
    # self.colors.contains? color
  end

  def handle
    if self.variant_type.name == 'Master'
      self.sku
    else
      self.sku.gsub(/-\d+\z/, '')
    end
  end

  def title
    self.design.name
  end

  def option_3_value
    self.substrate.name
  end

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
    self.design.product_type.product_category.name
  end

  def image_url position
    self.variant_images[position].file.url
  end

  def price
    self.design.price.to_s
  end

  # Variants which should not show up in search results should have only the
  # tag "legacy-sku" assigned to them. This will tell the Shopify system not
  # to display them except within their collections.
  def tags
    if self.suppress_from_searches
      'legacy__SKU'
    else
      tags = []

      tags << to_tags('color', self.colors.map { |c| c.name })
      tags << to_tags('style', self.design.styles.map { |s| s.name })
      tags << to_tag('type', self.design.product_type.name)

      if self.design.product_type.product_category.name == 'Digital'
        tags << %w[feature__digital feature__scale feature__design feature__material feature__color]
      end

      if self.design.keywords
        tags << to_tags('keyword', self.design.keywords.split(',')).map { |k| k.strip }
      end

      tags << self.design.design_properties.map { |dp| to_tag(dp.property.presentation, dp.value) }
      tags.flatten.join(', ')
    end
  end

  def to_tags name, values
    tags = []
    values.each do |value|
      tags << to_tag(name, value)
    end
    tags
  end

  def to_tag name, value
    "#{name}__#{value}"
  end

  def collection
    self.design.collection.name
  end

  def generate_tearsheet
    filename = Rails.root.join('tmp', self.sku+'.pdf')

    logo_img = open('https://s3.amazonaws.com/astek/Logo/ASTEK_LOGO_BLACK.png')
    variant_img = open(self.variant_images.first.file.large.url)

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

      pdf.bounding_box([0, pdf.cursor], width: 300, height: 25) do
        pdf.stroke_color '000000'
        pdf.fill_color '000000'
        pdf.fill_and_stroke_rectangle [pdf.cursor-25, pdf.cursor], 300, 25

        pdf.fill_color 'ffffff'
        pdf.move_down 8
        pdf.indent(10) do
          pdf.text self.name.upcase + ' / ' + self.sku.upcase
        end
        pdf.fill_color '000000'
      end

      pdf.move_down 12
      pdf.stroke_horizontal_rule

      pdf.move_down 15
      pdf.indent(10) do

        if self.substrate
          pdf.text 'MATERIAL: '+self.substrate.name
          pdf.move_down 6
        end

        if match_type = self.design.property('repeat_match_type')
          pdf.text 'MATCH TYPE: '+match_type
          pdf.move_down 6
        end

        if printed_width = self.design.property('printed_width')
          pdf.text 'PRINTED WIDTH: '+printed_width
          pdf.move_down 6
        end

        if repeat_height = self.design.property('repeat_height')
          pdf.text 'VERTICAL REPEAT: '+repeat_height
          pdf.move_down 6
        end

        if repeat_width = self.design.property('repeat_width')
          pdf.text 'MOTIF WIDTH: '+repeat_width
          pdf.move_down 6
        end

        if mural_width = self.design.property('mural_width')
          pdf.text 'MURAL WIDTH: '+mural_width
          pdf.move_down 6
        end

        if mural_height = self.design.property('mural_height')
          pdf.text 'MURAL HEIGHT: '+mural_height
          pdf.move_down 6
        end

        if self.substrate && self.substrate.backing_type
          pdf.text 'BACKING/TYPE: '+self.substrate.backing_type.name
          pdf.move_down 6
        end

        if fire_rating = self.design.property('fire_rating')
          pdf.text 'FIRE RATING: '+fire_rating
        end
        
      end

      pdf.move_down 12
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

      # pdf.move_down 12
      #
      pdf.font_size 10

      pdf.bounding_box([0, 20], width: 500, height: 30) do
        pdf.text '15924 Arminta St., Van Nuys CA 91406', align: :center
        pdf.text '818.901.9876  astek.com  info@astek.com  @astekinc', align: :center
      end

      # pdf.text Time.now.to_s



      pdf.render_file filename

    end

    file = File.new(filename)
    self.tearsheet = file
    self.save!
  end

end
