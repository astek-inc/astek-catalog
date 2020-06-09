class Collection < ApplicationRecord

  resourcify

  acts_as_paranoid

  include Websiteable

  include KeywordValidateable

  acts_as_taggable_on :keywords

  belongs_to :product_category, inverse_of: :collections

  has_many :designs, -> { order(row_order: :asc) }, dependent: :destroy
  has_many :design_aliases, -> { order(row_order: :asc) }, dependent: :destroy

  has_many :collection_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy

  has_many :subcollections, dependent: :destroy, inverse_of: :collection

  belongs_to :lead_time, optional: true

  default_scope { order(name: :asc) }

  validates_presence_of :name

  def designs_for_domain domain
    self.designs.for_domain domain
  end

end
