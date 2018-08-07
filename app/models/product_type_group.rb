class ProductTypeGroup < ActiveRecord::Base

  resourcify

  include RankedModel
  ranks :row_order

  acts_as_paranoid

  has_many :product_types, inverse_of: :product_type_group

  validates_presence_of :name

end
