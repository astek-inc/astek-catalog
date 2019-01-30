class ProductType < ActiveRecord::Base

  resourcify

  acts_as_paranoid

  has_many :variants, inverse_of: :product_type
  belongs_to :product_category, inverse_of: :product_types
  has_and_belongs_to_many :websites

  default_scope { order(name: :asc) }

  validates_presence_of :name, :product_category_id

end
