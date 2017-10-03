class CollectionImage < Image
  belongs_to :collection
  mount_uploader :file, CollectionImageUploader
  skip_callback :commit, :after, :remove_file! # To work with acts_as_paranoid
end
