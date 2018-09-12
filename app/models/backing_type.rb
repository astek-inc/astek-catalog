class BackingType < ActiveRecord::Base

  resourcify

  include RankedModel
  ranks :row_order

  acts_as_paranoid

  has_many :substrates, inverse_of: :backing_type
  has_many :variants, inverse_of: :backing_type

  validates :name, uniqueness: true

end
