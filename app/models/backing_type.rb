class BackingType < ActiveRecord::Base

  resourcify

  acts_as_paranoid

  include RankedModel
  ranks :row_order

  has_many :substrates, inverse_of: :backing_type
  has_many :variants, inverse_of: :backing_type

  # default_scope { order(name: :asc) }

  validates :name, uniqueness: true

end
