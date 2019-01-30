class ProductCategory < ActiveRecord::Base

  resourcify

  acts_as_paranoid

  has_many :product_types, inverse_of: :product_category
  has_many :collections, inverse_of: :product_category

  default_scope { order(name: :asc) }

  validates_presence_of :name

end
