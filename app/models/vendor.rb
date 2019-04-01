class Vendor < ApplicationRecord
  resourcify
  acts_as_paranoid
  has_many :designs, inverse_of: :vendor
  default_scope { order(:name) }
  validates :name, presence: true
end
