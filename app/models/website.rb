class Website < ApplicationRecord

  resourcify

  acts_as_paranoid

  validates :name, presence: true
  validates :domain, presence: true, uniqueness: { scope: :deleted_at }

  default_scope { order(name: :asc) }

  has_many :website_displays
  has_many :collections, through: :website_displays, source: :websiteable, source_type: 'Collection'
  has_many :designs, through: :website_displays, source: :websiteable, source_type: 'Design'
  has_many :variants, through: :website_displays, source: :websiteable, source_type: 'Variant'
  has_many :variant_install_images, through: :website_displays, source: :websiteable, source_type: 'VariantInstallImage'

  has_and_belongs_to_many :product_types

end
