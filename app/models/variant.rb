class Variant < ApplicationRecord

  resourcify

  include RankedModel
  ranks :row_order, with_same: :design_id

  acts_as_paranoid

  include Websiteable

  mount_uploader :tearsheet, TearsheetUploader

  belongs_to :design
  belongs_to :variant_type
  belongs_to :sale_unit, optional: true
  belongs_to :backing_type, optional: true

  has_many :variant_substrates
  has_many :substrates, through: :variant_substrates

  has_many :variant_swatch_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy
  has_many :variant_install_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy

  has_and_belongs_to_many :product_types
  has_and_belongs_to_many :colors

  validates :variant_type_id, presence: true
  validates :name, presence: true
  validates :sku, presence: true, uniqueness: true

  # def has_color? find_color
  #   self.colors.include? find_color
  # end

  scope :with_color, ->(color_name) { joins(:colors).where('colors.name = ?', color_name) }

  # For Shopify
  def title

    out = ''

    if self.design.collection.prepend_collection_name_to_design_names
      out += self.design.collection.name + ' | '
    end

    out += self.design.name

    if self.design.collection.append_collection_name_to_design_names
      out += ' | ' + self.design.collection.name
    end

    out

  end

  # Shopify sites require weight in grams, in whole numbers (no decimals)
  def variant_grams
    (self.weight * BigDecimal('453.592')).round.to_s unless self.weight.nil?
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
    self.design.vendor.name
  end

  def type
    self.design.collection.product_category.name
  end

  def swatch_image_url position
    if self.variant_swatch_images
      self.variant_swatch_images[position].file.url
    end
  end

  # For export to Shopify websites. Color is appended to ensure the product appears in search results.
  def sample_sku
    self.sku + '-s'
  end

  def sample_sku_with_substrate substrate
    self.sku + '-' + substrate.name_or_display_name.parameterize + '-s'
  end

  def sample_sku_with_custom_material custom_material
    self.sku + '-' + custom_material.name.parameterize + '-s'
  end

  def sku_with_colors
    self.sku + '__' + self.colors.map { |c| c.name.gsub(/\s+/, '-').downcase }.join('__')
  end

  def sku_with_substrate_and_colors substrate
    self.sku + '-' + substrate.name_or_display_name.parameterize + '__' + self.colors.map { |c| c.name.gsub(/\s+/, '-').downcase }.join('__')
  end

  def sku_with_custom_material_and_colors custom_material
    self.sku + '-' + custom_material.name.parameterize + '__' + self.colors.map { |c| c.name.gsub(/\s+/, '-').downcase }.join('__')
  end

  def install_images_for_domain domain
    self.variant_install_images.for_domain domain
  end

  def substrate_for_domain domain
    variant_substrates = self.variant_substrates.for_domain(domain)
    variant_substrates.first.substrate unless variant_substrates.empty?
  end

  def calculator_settings

    case self.sale_unit.name
    when 'Roll'
      width = self.design.property('roll_width_inches')
      if length = self.design.property('roll_length_yards')
        {
          note: "Indicate no. of Rolls <span>(1 Roll = #{width} in. x #{length} yd.)</span>",
          divisor: (BigDecimal(width, 9) * (BigDecimal(length, 9) * BigDecimal('36', 9))),
          minimum: self.minimum_quantity,
          sale_unit: %w[roll rolls]
        }.to_json
      elsif length = self.design.property('roll_length_feet')
        {
          note: "Indicate no. of Rolls <span>(1 Roll = #{width} in. x #{length} ft.)</span>",
          divisor: (BigDecimal(width, 9) * (BigDecimal(length, 9) * BigDecimal('12', 9))),
          minimum: self.minimum_quantity,
          sale_unit: %w[roll rolls]
        }.to_json
      end

    when 'Yard'
      width = self.design.property('roll_width_inches')
      length = '36'

      parenthetical_note = "#{width} in. wide roll, sold per yard."
      if self.minimum_quantity > 1
        parenthetical_note += " This product has a minimum order quantity of #{self.minimum_quantity} yards."
      end

      {
        note: "Indicate no. of Yards <span>(#{parenthetical_note})</span>",
        divisor: (BigDecimal(width, 9) * BigDecimal(length, 9)),
        minimum: self.minimum_quantity,
        sale_unit: %w[yard yards]
      }.to_json

    when 'Meter'
      width = self.design.property('roll_width_inches')
      length = '39.37'

      parenthetical_note = "#{width} in. wide roll, sold per meter."
      if self.minimum_quantity > 1
        parenthetical_note += " This product has a minimum order quantity of #{self.minimum_quantity} meters."
      end

      {
        note: "Indicate no. of Meters <span>(#{parenthetical_note})</span>",
        divisor: (BigDecimal(width, 9) * BigDecimal(length, 9)),
        minimum: self.minimum_quantity,
        sale_unit: %w[meter meters]
      }.to_json

    when 'Square Foot'
      {
        note: "Indicate no. of Square Feet<br><span>This product is custom printed. Minimum order quantity of #{self.minimum_quantity} square feet. We suggest adding an additional 20-30% overage to be sure you're covered!</span>",
        divisor: 144,
        minimum: self.minimum_quantity,
        sale_unit: ['square foot', 'square feet']
      }.to_json

    when 'Set'

      # If we have dimensions for the whole mural, we'll use those. Otherwise,
      # we'll use the dimensions of each panel and multiply by the number of panels.
      if (self.design.property('mural_width_inches') && self.design.property('mural_height_inches'))
        width = self.design.property('mural_width_inches')
        height = self.design.property('mural_height_inches')
        divisor = BigDecimal(width, 9) * BigDecimal(height, 9)
      else
        width = self.design.property 'panel_width_inches'
        height = self.design.property 'panel_height_inches'
        quantity = self.design.property 'panels_per_set'
        divisor = (BigDecimal(width, 9) * BigDecimal(height, 9) * BigDecimal(quantity, 9))
      end

      {
        note: "Indicate no. of Sets of #{quantity} Panels<br><span>Minimum order quantity of #{self.minimum_quantity} set. We suggest adding an additional 20-30% overage to be sure you're covered!</span>",
        divisor: divisor,
        minimum: self.minimum_quantity,
        sale_unit: ['set', 'sets']
      }.to_json

    when 'Panel'
      width = self.design.property 'panel_width_inches'
      height = self.design.property 'panel_height_inches'
      {
        note: "Indicate no. of Panels<br><span>We suggest adding an additional 20-30% overage to be sure you're covered!</span>",
        divisor: (BigDecimal(width, 9) * BigDecimal(height, 9)),
        minimum: self.minimum_quantity,
        sale_unit: ['panel', 'panels']
      }.to_json
    end

  end

end
