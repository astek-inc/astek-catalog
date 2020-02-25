require "#{Rails.root}/lib/admin/import_product_from_csv_item.rb"

require 'csv'

namespace :db do

  desc 'Import product data from a CSV file'
  task product_import: :environment do

    user = User.find_by(email: 'edwin@astek.com')
    # Admin::ProductImportsMailer.with(user: user, collection_name: 'Xxx', csv_url: 'test').import_complete_email.deliver_now


      if import = ProductImport.where(imported: false).first

        CSV.parse(URI.open(import.file.url).read, headers: true).each do |row|

          begin
            @item = OpenStruct.new(row.to_h)
            ::Admin::ImportProductFromCsvItem.import item
            puts '- - -'
          rescue => e
            # puts e.message
            # puts item
            Admin::ProductImportsMailer.with(user: user, error_message: e.message, item: @item, csv_url: import.file.url)
            raise
          end

        end

        import.update_attribute(:imported, true)

        Admin::ProductImportsMailer.with(user: user, collection_name: @item.collection, csv_url: import.file.url).import_complete_email.deliver_now
      end

  end
end
