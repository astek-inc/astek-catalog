class ProductImport < ApplicationRecord

  resourcify

  mount_uploader :file, ProductImportUploader
end
