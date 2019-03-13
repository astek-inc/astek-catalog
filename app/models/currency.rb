class Currency < ActiveRecord::Base

  resourcify

  has_many :countries

  default_scope { order(name: :asc) }

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

end
