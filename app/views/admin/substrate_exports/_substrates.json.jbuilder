@substrates.each do |substrate|
  key = (substrate.display_name.present? ? substrate.display_name : substrate.name).parameterize
  json.set! "#{key}" do
    json.name (substrate.display_name.present? ? substrate.display_name : substrate.name)
    json.description substrate.display_description
  end
  json.prettify!
end
