class ProductCategory < ActiveRecord::Base

  resourcify

  include RankedModel
  ranks :row_order

  acts_as_paranoid

  has_many :product_types, inverse_of: :product_category
  has_many :collections, inverse_of: :product_category

  validates_presence_of :name

end
