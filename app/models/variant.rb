class Variant < ApplicationRecord

  resourcify

  include RankedModel
  ranks :row_order, with_same: :design_id

  acts_as_paranoid

  mount_uploader :tearsheet, TearsheetUploader

  belongs_to :design
  belongs_to :variant_type
  belongs_to :substrate, optional: true
  belongs_to :backing_type, optional: true

  has_many :variant_swatch_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy
  has_many :variant_install_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy

  has_and_belongs_to_many :product_types
  has_and_belongs_to_many :colors

  validates :variant_type_id, presence: true
  validates :name, presence: true
  validates :sku, presence: true

  def has_color? color
    # self.colors.contains? color
  end

  def title
    self.design.name
  end

  # def option_3_value
  #   if self.substrate
  #     self.substrate.name
  #   elsif self.backing_type
  #     self.backing_type.name
  #   end
  # end

  # Sites require weight in grams, in whole numbers (no decimals)
  def variant_grams
    (self.weight * BigDecimal('453.592')).round.to_s
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

end
