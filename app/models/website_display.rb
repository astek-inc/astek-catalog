class WebsiteDisplay < ApplicationRecord
  self.table_name = 'website_display'
  belongs_to :website
  belongs_to :websiteable, :polymorphic => true
end
