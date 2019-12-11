class Description < ApplicationRecord

  include Websiteable

  belongs_to :descriptionable, polymorphic: true

end
