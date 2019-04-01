class Country < ApplicationRecord

  resourcify

  has_many :states
  has_many :designs, inverse_of: :country_of_origin

  belongs_to :currency

  default_scope { order(name: :asc) }

  validates :name, presence: true
  validates :iso_name, presence: true, uniqueness: true
  validates :iso, presence: true, uniqueness: true
  validates :iso3, presence: true, uniqueness: true
  validates :numcode, presence: true, uniqueness: true

end
