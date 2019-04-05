require "#{Rails.root}/lib/admin/import_product_from_csv_item.rb"

require 'csv'

namespace :db do

  desc 'Import product data from a CSV file'
  task product_import: :environment do

    if import = ProductImport.where(imported: false).first
      CSV.parse(URI.open(import.file.url).read, headers: true).each do |row|
        item = OpenStruct.new(row.to_h)
        ::Admin::ImportProductFromCsvItem.import item
        puts '- - -'
      end
      import.update_attribute(:imported, true)
    end

  end
end
