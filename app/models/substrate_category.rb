class SubstrateCategory < ActiveRecord::Base

  resourcify

  acts_as_paranoid

  has_and_belongs_to_many :substrates

  validates :name, presence: true

  default_scope { order(:name) }

end
