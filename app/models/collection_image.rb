class CollectionImage < Image
  belongs_to :collection
  mount_uploader :file, CollectionImageUploader
end
