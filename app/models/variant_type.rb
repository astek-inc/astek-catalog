class VariantType < ActiveRecord::Base

  resourcify

  acts_as_paranoid

  has_many :variants

  validates :name, uniqueness: true

end
