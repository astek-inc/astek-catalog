class VariantType < ApplicationRecord

  resourcify

  acts_as_paranoid

  has_many :variants

  default_scope { order(name: :asc) }

  validates :name, uniqueness: true

end
