class Variant < ApplicationRecord

  resourcify

  include RankedModel
  ranks :row_order, with_same: :design_id

  acts_as_paranoid

  include Websiteable

  mount_uploader :tearsheet, TearsheetUploader

  belongs_to :design
  belongs_to :variant_type
  belongs_to :substrate, optional: true
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

  def title

    out = ''

    if self.design.collection.prepend_collection_name_to_design_names
      out += self.design.collection.name + ' | ' + self.design.name
    end

    out += self.design.name

    if self.design.collection.append_collection_name_to_design_names
      out += ' | ' + self.design.collection.name
    end

    out

  end

  # Sites require weight in grams, in whole numbers (no decimals)
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

  def price
    self.design.price.to_s
  end

  # For export to Shopify websites. Color is appended to ensure the product appears in search results.
  def sample_sku
    self.sku + '-s'
  end

  def sample_sku_with_material material
    self.sku + '-' + material.name.parameterize + '-s'
  end

  def sku_with_colors
    self.sku + '__' + self.colors.map { |c| c.name.gsub(/\s+/, '-').downcase }.join('__')
  end

  def sku_with_material_and_colors material
    self.sku + '-' + material.name.parameterize + '__' + self.colors.map { |c| c.name.gsub(/\s+/, '-').downcase }.join('__')
  end

  def install_images_for_domain domain
    self.variant_install_images.for_domain domain
  end

  def substrate_for_domain domain
    variant_substrates = self.variant_substrates.for_domain(domain)
    variant_substrates.first.substrate unless variant_substrates.empty?
  end

end
