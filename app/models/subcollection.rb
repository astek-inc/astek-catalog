class Subcollection < ApplicationRecord

  resourcify

  has_many :designs, inverse_of: :subcollection
  belongs_to :subcollection_type, inverse_of: :subcollections
  belongs_to :collection, inverse_of: :subcollections

  validates :name, presence: true
  validates :subcollection_type_id, presence: true

  def install_images
    self.designs.map { |d| d.variants.map { |v| v.variant_install_images.first.nil? ? nil : { variant_id: v.id, install_image: v.variant_install_images.first } } }.compact.flatten
  end
end
