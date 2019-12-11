require "#{Rails.root}/lib/admin/fedex_crossborder_csv_generator.rb"

module Admin
  class FedexSkusExportJob < ActiveJob::Base

    queue_as :default

    def perform(skus, current_user)

      sku_array = skus.split(',').map { |s| s.strip }
      website = Website.find_by(domain: 'astekhome.com')
      designs = Design.where(sku: sku_array).select { |d| d.collection.websites.include? website }

      csv_data = ''
      designs.each do |design|
        csv_data += ::Admin::FedexCrossborderCsvGenerator.fedex_crossborder_csv design, csv_data.empty?
      end

      if sku_array.length < 10
        skus_for_filename = sku_array.map { |s| s.downcase.gsub(/[^a-z0-9]/, '') }.join('-')
      else
        skus_for_filename = 'assorted-skus'
      end

      filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-#{website.name.parameterize}-fedex-product-export-#{skus_for_filename}.csv"

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
      ProductExportsMailer.with(user: current_user, skus: skus, csv_url: csv_url).skus_notification_email.deliver_now

    end

  end

end
