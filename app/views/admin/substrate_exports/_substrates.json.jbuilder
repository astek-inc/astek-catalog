@substrates.each do |substrate|
  key = (substrate.display_name.present? ? substrate.display_name : substrate.name).parameterize
  json.set! "#{key}" do
    json.name (substrate.display_name.present? ? substrate.display_name : substrate.name)
    json.description ( substrate.descriptions.for_domain(@website.domain).first.description )
    if @website.domain == 'astek.com'
      json.images do
        json.print substrate.substrate_print_images.first.file.url
        json.texture substrate.substrate_texture_images.first.file.url
      end
    end
  end
  json.prettify!
end
