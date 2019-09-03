require "#{Rails.root}/lib/admin/product_data_csv_generator.rb"

module Admin
  class ShopifySkusExportJob < ActiveJob::Base

    queue_as :default

    def perform(skus, website_id, current_user)

      sku_array = skus.split(',').map { |s| s.strip }
      website = Website.find(website_id)
      designs = Design.where(sku: sku_array).select { |d| d.collection.websites.include? website }

      csv_data = ''
      skus_to_process = []
      errors = []
      designs.each do |design|
        if design.subcollection
          errors << design
          next
        end

        skus_to_process << design.sku
        csv_data += ::Admin::ProductDataCsvGenerator.product_data_csv design, website.domain, csv_data.empty?
      end

      if skus_to_process.any?

        if skus_to_process.length < 10
          skus_for_filename = skus_to_process.map { |s| s.downcase.gsub(/[^a-z0-9]/, '') }.join('-')
        else
          skus_for_filename = 'assorted-skus'
        end

        filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-#{website.name.parameterize}-shopify-product-export-#{skus_for_filename}.csv"

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

        if errors.any?
          sku_list = errors.map { |d| d.sku }.to_sentence
          error_message = "The SKUs #{sku_list} are part of subcollections and cannot be exported independently."
        else
          error_message = nil
        end

        ProductExportsMailer.with(user: current_user, skus: skus_to_process.to_sentence, csv_url: csv_url, error_message: error_message).skus_notification_email.deliver_now

      else
        sku_list = errors.map { |d| d.sku }.to_sentence
        error_message = "The export could not be processed because the SKUs #{sku_list} are part of subcollections and cannot be exported independently."
      end

    end
  end
end
