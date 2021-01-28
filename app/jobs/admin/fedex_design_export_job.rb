require "#{Rails.root}/lib/admin/fedex_crossborder_csv_generator.rb"

module Admin
  class FedexDesignExportJob < ActiveJob::Base

    queue_as :default

    def perform(design_id, current_user)

      design = Design.find(design_id)
      website = Website.find_by(domain: 'astekhome.com')

      if design.websites.include?(website) &&
        design.variants.for_domain('astekhome.com').first.stock_items.for_domain('astekhome.com').first.price.present? &&
        design.variants.for_domain('astekhome.com').first.stock_items.for_domain('astekhome.com').first.price > 0 &&
        design.country_id.present?

        csv_data = ::Admin::FedexCrossborderCsvGenerator.fedex_crossborder_csv design, true
        filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-#{website.name.parameterize}-fedex-product-export-#{design.name.parameterize}.csv"

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
