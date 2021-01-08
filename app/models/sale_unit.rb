class SaleUnit < ApplicationRecord

  resourcify

  acts_as_paranoid

  has_many :variants

  default_scope { order(:name) }

  validates :name, presence: true

end
