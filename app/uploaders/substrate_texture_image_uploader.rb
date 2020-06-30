class SubstrateTextureImageUploader < ImageUploader

  # Create different versions of your uploaded files:
  version :large do
    process resize_to_fit: [1000, 600]
  end

  version :small do
    process resize_to_fit: [250, 150]
  end

  version :thumb do
    process resize_to_fit: [50, 30]
  end

  def filename
    if original_filename
      name = [
          model.substrate.name.parameterize(separator: '_'),
          'texture'
      ].join('_')
      "#{name}.#{file.extension}"
    end
  end

end
