class VariantSubstrate < ApplicationRecord

  resourcify

  include Websiteable

  belongs_to :variant, inverse_of: :variant_substrates
  belongs_to :substrate, inverse_of: :variant_substrates

end