class SubstrateImage < Image
  belongs_to :substrate
  mount_uploader :file, SubstrateImageUploader
  skip_callback :commit, :after, :remove_file! # To work with acts_as_paranoid
end
