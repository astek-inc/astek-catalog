# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "#{Rails.root}/lib/admin/import_product_from_csv_item.rb"
require "#{Rails.root}/lib/admin/tearsheet_generator.rb"

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
    ::Admin::ImportProductFromCsvItem.import item
    puts '- - -'
  end

  Seed.create!(filename: filename)

end

puts 'Done'
