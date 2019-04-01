class ProductType < ApplicationRecord

  resourcify

  acts_as_paranoid

  belongs_to :product_category, inverse_of: :product_types
  has_and_belongs_to_many :websites
  has_and_belongs_to_many :variants

  default_scope { order(name: :asc) }

  validates_presence_of :name, :product_category_id

end
