require "#{Rails.root}/lib/admin/product_data_csv_generator.rb"
require "#{Rails.root}/lib/admin/product_subcollection_data_csv_generator.rb"

module Admin
  class ShopifyAllExportJob < ActiveJob::Base

    queue_as :default

    def perform(website_id, current_user)

      website = Website.find(website_id)

      csv_data = ''
      Collection.includes(:websites).where(websites: { id: website_id }).each do |collection|

        collection.designs.available.unsubcollected.for_domain(website.domain).each do |design|
          csv_data += ::Admin::ProductDataCsvGenerator.product_data_csv design, website.domain, csv_data.empty?
        end

        collection.subcollections.each do |subcollection|
          csv_data += ::Admin::ProductSubcollectionDataCsvGenerator.product_data_csv subcollection, website.domain, csv_data.empty?
        end

      end

      filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-#{website.name.parameterize}-shopify-product-export-all.csv"

      storage = Fog::Storage.new(
          provider: 'AWS',
          aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
          region: 'us-west-2',
          path_style: true
      )

      directory = storage.directories.get('product-data-export')
      uploaded = directory.files.create(
          key: filename,
          body: csv_data,
          public: true
      )

      puts 'Uploaded file '+filename+' to S3'

      csv_url = "https://s3-us-west-2.amazonaws.com/product-data-export/#{filename}"
      ProductExportsMailer.with(user: current_user, website: website, csv_url: csv_url).all_notification_email.deliver_now

    end

  end

end
