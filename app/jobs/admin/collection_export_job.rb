require "#{Rails.root}/lib/admin/product_data_csv_generator.rb"

module Admin
  class CollectionExportJob < ActiveJob::Base

    queue_as :default

    # def perform(collection_name, website_domain)
    def perform(collection, website, current_user)

      # website = Website.find_by!(domain: website_domain)
      # collection = Collection.find_by(name: collection_name)

      csv_data = ''
      puts 'Getting data for '+collection.name
      collection.designs.available.each do |design|
        csv_data += ::Admin::ProductDataCsvGenerator.product_data_csv design, website.domain, csv_data.empty?
      end

      filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-#{website.name.parameterize}-product-export-#{collection.name.parameterize}.csv"

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
      ProductExportsMailer.with(user: current_user, collection: collection, csv_url: csv_url).notification_email.deliver_now

    end

  end

end
