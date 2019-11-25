require "#{Rails.root}/lib/admin/product_data_csv_generator.rb"

module Admin
  class ShopifyDesignExportJob < ActiveJob::Base

    queue_as :default

    def perform(design_id, website_id, current_user)

      design = Design.find(design_id)
      website = Website.find(website_id)

      if design.subcollection

        error_message = "This design is part of the subcollection #{design.subcollection.name} (ID #{design.subcollection.id}) and cannot be exported independently."
        ProductExportsMailer.with(user: current_user, design: design, error_message: error_message).design_failure_email.deliver_now

      else

        csv_data = ::Admin::ProductDataCsvGenerator.product_data_csv design, website.domain, true
        filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-#{website.name.parameterize}-shopify-product-export-#{design.name.parameterize}.csv"

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
        ProductExportsMailer.with(user: current_user, design: design, csv_url: csv_url).design_notification_email.deliver_now

      end

    end

  end

end
