class VariantInstallImageUploader < ImageUploader

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

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    if original_filename

      name = [
          model.variant.sku,
          model.variant.design.name.gsub(/[^A-Za-z0-9]/, '_').gsub(/_+/, '_'),
          model.variant.name.gsub(/[^A-Za-z0-9]/, '').upcase,
          'install'
      ].join('_')

      "#{name}.#{file.extension}"
      
    end
  end

end
