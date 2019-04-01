class LeadTime < ApplicationRecord

  resourcify

  acts_as_paranoid

  has_many :collections

  default_scope { order(name: :asc) }

  validates :name, presence: true, uniqueness: true

end
