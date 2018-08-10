class ProductType < ActiveRecord::Base

  resourcify

  include RankedModel
  ranks :row_order, with_same: :product_category_id

  acts_as_paranoid

  has_many :designs, inverse_of: :product_type

  # has_many :product_type_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy

  belongs_to :product_category, inverse_of: :product_types

  validates_presence_of :name, :product_category_id

end
