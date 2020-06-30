class SubstrateTextureImage < Image
  belongs_to :substrate, foreign_key: :owner_id
  mount_uploader :file, SubstrateTextureImageUploader
  # skip_callback :commit, :after, :remove_file! # To work with acts_as_paranoid
end
