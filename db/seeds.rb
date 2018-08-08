# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'Seeding product data'

DATA_DIR = 'seeds'

require 'csv'
# require 'pp'

properties = Property.all
path = File.join(__dir__, DATA_DIR, 'upload-test.csv')
csv = CSV.read(path, headers: true)

csv.each do |row|
    item = OpenStruct.new(row.to_h)

    vendor = Vendor.find_by!({ name: item.vendor })
    product_type_group = ProductTypeGroup.find_by!( { name: item.product_type_group })
    product_type = ProductType.find_by!( { name: item.product_type, product_type_group: product_type_group })
    sale_unit = SaleUnit.find_by!({ name: item.sale_unit })
    styles = Style.where(name: item.style.split(',').map { |s| s.strip })
    variant_type = VariantType.find_by!({ name: item.variant_type })
    substrate = Substrate.find_by(name: item.substrate)

    collection = Collection.find_or_create_by!({ name: item.collection, product_type: product_type, vendor: vendor })

    design = Design.find_or_create_by!({ name: item.design_name, collection: collection }) do |d|
      # If we got here, this is a new record
      d.description = item.description
      d.keywords = item.keywords
      d.price = item.price
      d.sale_unit = sale_unit
      d.available_on = Time.now
    end
    design.styles << styles

    properties.each do |p|
      if ip = item.send(p.name)
        # puts p.presentation + ': ' + ip
        unless design.property(p.name)
          design.design_properties << DesignProperty.create(design: design, property: Property.find_by(name: p.name), value: ip)
        end
      end
    end

    variant = Variant.create!({
        design: design,
        variant_type: variant_type,
        name: item.variant_name,
        sku: item.sku,
        substrate: substrate
    })

    item.images.split(',').map { |i| i.strip }.each do |url|
      VariantImage.create!({
        remote_file_url: url,
        type: 'VariantImage',
        owner_id: variant.id
      })
    end

    variant.colors << Color.where(name: item.color.split(',').map { |c| c.strip })

  if collection.product_type_group.name == 'Digital'
    variant.generate_tearsheet
  end

end
