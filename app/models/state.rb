class State < ActiveRecord::Base

  resourcify

  belongs_to :country

  default_scope { order(name: :asc) }

  validates :name, presence: true
  validates :abbr, presence: true, uniqueness: { scope: :country_id, message: 'already taken for this country' }

end
