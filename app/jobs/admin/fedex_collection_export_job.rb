require "#{Rails.root}/lib/admin/fedex_crossborder_csv_generator.rb"

module Admin
  class FedexCollectionExportJob < ActiveJob::Base

    queue_as :default

    def perform(collection_id, current_user)

      collection = Collection.find(collection_id)
      website = Website.find_by(domain: 'astekhome.com')

      csv_data = ''
      collection.designs.available.for_domain('astekhome.com').each do |design|
        if design.variants.for_domain('astekhome.com').first.stock_items.for_domain('astekhome.com').first.price.present? &&
          design.variants.for_domain('astekhome.com').first.stock_items.for_domain('astekhome.com').first.price > 0 &&
          design.country_id.present?
          csv_data += ::Admin::FedexCrossborderCsvGenerator.fedex_crossborder_csv design, csv_data.empty?
        end
      end

      filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-#{website.name.parameterize}-fedex-product-export-#{collection.name.parameterize}.csv"

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
      ProductExportsMailer.with(user: current_user, collection: collection, csv_url: csv_url).collection_notification_email.deliver_now

    end

  end

end
