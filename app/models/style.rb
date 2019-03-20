class Style < ApplicationRecord

  resourcify

  has_and_belongs_to_many :designs

  validates :name, presence: true, uniqueness: true

  default_scope { order(name: :asc) }

end
