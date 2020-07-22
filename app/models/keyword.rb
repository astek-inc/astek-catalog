class Keyword < ApplicationRecord

  resourcify

  default_scope { order(name: :asc) }

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  before_save { name.downcase! }

end
