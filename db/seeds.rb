# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


require 'csv'
# require 'pp'

DATA_DIR = 'seeds'

puts 'Seeding product data'
puts $\

properties = Property.all

dirpath = File.join(__dir__, DATA_DIR)
Dir.glob(dirpath+'/*.csv') do |filepath|

  puts '- '*40

  filename = File.basename(filepath)
  # next if Seed.find_by filename: filename
  if Seed.find_by filename: filename
    puts filename+' already processed'
    puts $\
    next
  end

  puts 'Reading '+filename
  puts $\

  csv = CSV.read(filepath, headers: true)

  csv.each do |row|

    item = OpenStruct.new(row.to_h)

    puts 'Finding relevant information'

    vendor = Vendor.find_by!({ name: item.vendor })
    product_category = ProductCategory.find_by!( { name: item.product_category })
    product_type = ProductType.find_by!( { name: item.product_type })
    sale_unit = SaleUnit.find_by!({ name: item.sale_unit })
    styles = Style.where(name: item.style.split(',').map { |s| s.strip }) unless item.style.nil?
    variant_type = VariantType.find_by!({ name: item.variant_type })

    if item.substrate
      substrate = Substrate.find_by(name: item.substrate)
      backing = nil
    elsif item.backing
      backing_type = BackingType.find_by(name: item.backing)
      substrate = nil
    else
      raise 'Invalid or missing substrate/backing information'
    end

    puts 'Finding or creating collection information for '+item.collection
    collection = Collection.find_or_create_by!({ name: item.collection, product_category: product_category, vendor: vendor }) do |c|
      # If we got here, this is a new record
      domains = []
      unless item.websites.nil?
        item.websites.split(',').map { |s| s.strip }.each do |key|
          case key
          when 'A'
            domains << 'astek.com'
          when 'H'
            domains << 'astekhome.com'
          when 'O'
            domains << 'onairdesign.com'
          end
        end
        c.websites = Website.where(domain: domains)
      end
    end

    puts 'Finding or creating design information for '+item.design_name
    design = Design.find_or_create_by!({ sku: item.design_sku, name: item.design_name, collection: collection }) do |d|
      # If we got here, this is a new record
      d.product_type = product_type
      d.description = item.description
      d.keywords = item.keywords
      d.price = BigDecimal(item.price.gsub(/,/, ''), 2)
      d.sale_unit = sale_unit
      d.weight = BigDecimal(item.weight.gsub(/,/, ''), 2)
      d.available_on = Time.now
      d.styles = styles
    end

    properties.each do |p|
      if ip = item.send(p.name)
        # puts p.presentation + ': ' + ip
        unless design.property(p.name)
          design.design_properties << DesignProperty.create(design: design, property: Property.find_by(name: p.name), value: ip)
        end
      end
    end

    puts 'Creating variants'
    variant = Variant.create!({
      design: design,
      variant_type: variant_type,
      name: item.variant_name,
      sku: item.sku,
      substrate: substrate,
      backing_type: backing_type
    })

    puts 'Processing images'
    item.images.split(',').map { |i| i.strip }.each do |url|
      VariantImage.create!({
        remote_file_url: url,
        type: 'VariantImage',
        owner_id: variant.id
      })
    end

    variant.colors << Color.where(name: item.color.split(',').map { |c| c.strip }) unless item.color.nil?

    if collection.product_category.name == 'Digital'
      variant.generate_tearsheet
    end

    puts $\
  end

  Seed.create!(filename: filename)

end

puts 'Done'
