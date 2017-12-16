class Website < ActiveRecord::Base

  resourcify

  acts_as_paranoid

  has_and_belongs_to_many :collections

  validates :name, presence: true
  validates :domain, presence: true

end
