class Vendor < ActiveRecord::Base
  resourcify
  acts_as_paranoid
  has_many :collections
  default_scope { order(:name) }
  validates :name, presence: true
end
