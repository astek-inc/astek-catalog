class ProductType < ActiveRecord::Base

  resourcify

  include RankedModel
  ranks :row_order, with_same: :product_type_group_id

  acts_as_paranoid

  has_many :collections, inverse_of: :product_type
  has_many :product_type_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy
  belongs_to :product_type_group, inverse_of: :product_types

  validates_presence_of :name, :product_type_group_id

end
