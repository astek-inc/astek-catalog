class Collection < ActiveRecord::Base

  resourcify

  extend FriendlyId
  friendly_id :name, use: :slugged

  include RankedModel
  ranks :row_order, with_same: :product_category_id

  acts_as_paranoid

  belongs_to :product_category, inverse_of: :collections
  belongs_to :vendor, inverse_of: :collections

  has_many :designs, dependent: :destroy
  has_many :collection_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy

  belongs_to :lead_time

  has_and_belongs_to_many :websites

  # delegate :product_category, to: :product_type, allow_nil: true

  validates_presence_of :name

end
