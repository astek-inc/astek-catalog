class Collection < ActiveRecord::Base

  resourcify

  acts_as_paranoid

  belongs_to :product_category, inverse_of: :collections

  has_many :designs, -> { order(row_order: :asc) }, dependent: :destroy
  has_many :collection_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy

  belongs_to :lead_time

  has_and_belongs_to_many :websites

  default_scope { order(name: :asc) }

  validates_presence_of :name

end
