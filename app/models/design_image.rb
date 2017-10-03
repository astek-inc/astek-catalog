class DesignImage < Image
  belongs_to :design
  mount_uploader :file, DesignImageUploader
end
