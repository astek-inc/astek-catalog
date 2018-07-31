class Variant < ActiveRecord::Base

  resourcify

  extend FriendlyId
  friendly_id :name, use: :slugged

  include RankedModel
  ranks :row_order, with_same: :design_id

  acts_as_paranoid

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

  def published?
    self.design.available_on < Time.now && ( self.design.expires_on.nil? || self.design.expires_on > Time.now ) && self.design.deleted_at.nil?
  end

  def description
    self.design.description
  end

  def vendor
    self.design.collection.vendor.name
  end

  def type
    self.design.collection.product_type.name
  end

  def image_url position
    self.variant_images[position].file.url
  end

  def image_alt_text
    "#{self.name} #{self.type} wallcovering design"
  end

  def price
    self.design.price.to_s
  end

  def tags
    tags = []
    tags << to_tags('color', self.colors.map { |c| c.name })
    tags << self.design.design_properties.map { |dp| to_tag(dp.property.presentation, dp.value) }
    tags.flatten.join(', ')
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

end
