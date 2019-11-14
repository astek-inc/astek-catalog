module Websiteable
  extend ActiveSupport::Concern

  included do

    has_many :website_displays, as: :websiteable, dependent: :destroy
    has_many :websites, through: :website_displays

    scope :for_domain, ->(domain) { joins(:website_displays).joins(:websites).where('websites.domain = ?', domain).uniq }

  end
end
