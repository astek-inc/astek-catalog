class VariantSwatchImage < Image
  belongs_to :variant
  mount_uploader :file, VariantSwatchImageUploader
  skip_callback :commit, :after, :remove_file! # To work with acts_as_paranoid
end
