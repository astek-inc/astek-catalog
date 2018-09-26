class LeadTime < ActiveRecord::Base

  resourcify

  include RankedModel
  ranks :row_order

  acts_as_paranoid

  has_many :collections

  validates :name, presence: true, uniqueness: true

end
