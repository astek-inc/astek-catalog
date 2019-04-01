class DesignImage < Image
  belongs_to :design, foreign_key: :owner_id
  mount_uploader :file, DesignImageUploader
  # skip_callback :commit, :after, :remove_file! # To work with acts_as_paranoid
end
