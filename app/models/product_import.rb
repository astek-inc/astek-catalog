class ProductImport < ApplicationRecord

  resourcify

  mount_uploader :file, ProductImportUploader

  default_scope { order(created_at: :desc) }

end
