module Descriptionable
  extend ActiveSupport::Concern

  included do
    has_many :descriptions, as: :descriptionable
  end
end
