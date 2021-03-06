class SaleUnit < ApplicationRecord

  resourcify

  acts_as_paranoid

  has_many :designs, inverse_of: :sale_unit

  default_scope { order(:name) }

  validates :name, presence: true

end
