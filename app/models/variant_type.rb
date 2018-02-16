class VariantType < ActiveRecord::Base

  acts_as_paranoid

  has_many :variants

  validates :name, uniqueness: true

end
