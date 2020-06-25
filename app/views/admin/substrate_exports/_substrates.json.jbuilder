@substrates.each do |substrate|
  key = (substrate.display_name.present? ? substrate.display_name : substrate.name).parameterize
  json.set! "#{key}" do
    json.name (substrate.display_name.present? ? substrate.display_name : substrate.name)
    json.description ( substrate.descriptions.for_domain(@website.domain).first.description )
    json.images substrate.substrate_images.map { |im | im.file.url } if @website.domain == 'astek.com'
  end
  json.prettify!
end
