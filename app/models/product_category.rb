class ProductCategory < ApplicationRecord

  resourcify

  acts_as_paranoid

  has_many :collections, inverse_of: :product_category

  default_scope { order(name: :asc) }

  validates_presence_of :name

end
