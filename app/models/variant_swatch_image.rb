class VariantSwatchImage < Image
  belongs_to :variant, foreign_key: :owner_id
  mount_uploader :file, VariantSwatchImageUploader
  # skip_callback :commit, :after, :remove_file! # To work with acts_as_paranoid
end
