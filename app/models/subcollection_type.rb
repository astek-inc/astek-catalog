class SubcollectionType < ApplicationRecord

  resourcify
  acts_as_paranoid

  has_many :subcollections, inverse_of: :subcollection_type

  default_scope { order(name: :asc) }
  validates :name, uniqueness: true

end
