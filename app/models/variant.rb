class Variant < ActiveRecord::Base

  TYPES = [
      { name: 'color_way', presentation: 'Color Way' },
      { name: 'master', presentation: 'Master' }
  ]

  resourcify

  extend FriendlyId
  friendly_id :name, use: :slugged

  include RankedModel
  ranks :row_order, with_same: :design_id

  acts_as_paranoid

  belongs_to :design
  has_many :variant_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy

  validates :variant_type, presence: true
  validates :name, presence: true
  validates :sku, presence: true
  validates :price_code, presence: true
  validates :slug, presence: true, on: :update

end
