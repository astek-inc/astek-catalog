class Variant < ActiveRecord::Base

  resourcify

  extend FriendlyId
  friendly_id :name, use: :slugged

  include RankedModel
  ranks :row_order, with_same: :design_id

  acts_as_paranoid

  belongs_to :design
  belongs_to :variant_type
  has_many :variant_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy
  has_and_belongs_to_many :colors

  validates :variant_type_id, presence: true
  validates :name, presence: true
  validates :sku, presence: true
  validates :price_code, presence: true
  validates :slug, presence: true, on: :update

  # def has_color? find_color
  #   self.colors.include? find_color
  # end

  scope :with_color, ->(color_name) { joins(:colors).where('colors.name = ?', color_name) }

end
