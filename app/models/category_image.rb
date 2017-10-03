class CategoryImage < Image
  belongs_to :category
  mount_uploader :file, CategoryImageUploader
  skip_callback :commit, :after, :remove_file! # To work with acts_as_paranoid
end
