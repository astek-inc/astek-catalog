require "#{Rails.root}/lib/admin/digital_products_by_sku_csv_generator.rb"

module Admin
  class DigitalProductsReportBySkuJob < ActiveJob::Base

    queue_as :default

    def perform(current_user)

      csv_data = ''
      Design.digital.each do |design|
        csv_data += ::Admin::DigitalProductsBySkuCsvGenerator.digital_products_by_sku_csv design, csv_data.empty?
      end

      filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-digital-products-by-sku.csv"

      storage = Fog::Storage.new(
          provider: 'AWS',
          aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
          region: 'us-west-2',
          path_style: true
      )

      directory = storage.directories.get('product-data-reports')
      uploaded = directory.files.create(
          key: filename,
          body: csv_data,
          public: true
      )

      puts '- '*40
      puts 'Uploaded file '+filename+' to S3'
      puts '- '*40

      csv_url = "https://product-data-reports.s3-us-west-2.amazonaws.com/#{filename}"
      # csv_url = "https://s3-us-west-2.amazonaws.com/product-data-reports/#{filename}"
      ReportsMailer.with(user: current_user, csv_url: csv_url).digital_products_by_sku_notification_email.deliver_now

    end

  end

end
