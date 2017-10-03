class CategoryImage < Image
  belongs_to :category
  mount_uploader :file, CategoryImageUploader
end
