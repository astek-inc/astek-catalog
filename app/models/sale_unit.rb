class SaleUnit < ActiveRecord::Base
  resourcify
  acts_as_paranoid
  has_many :designs
  default_scope { order(:name) }
  validates :name, presence: true
end
