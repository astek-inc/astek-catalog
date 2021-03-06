require "#{Rails.root}/lib/admin/shopify_design_data_csv_generator.rb"

namespace :db do
  desc 'Export all products that are flagged to show on a given domain'
  task :bulk_product_export => :environment do

    if !domain = ENV['DOMAIN']
      raise 'Domain not specified'
    end

    puts 'Getting product information to export for '+domain

    website = Website.find_by!(domain: domain)
    collections = Collection.includes(:websites).where(websites: { domain: domain })

    csv_data = ''
    collections.each_with_index do |collection, i|
      puts 'Getting data for '+collection.name

      collection.designs.available.each do |design|
        csv_data += Admin::ShopifyDesignDataCsvGenerator.product_data_csv design, domain, csv_data.empty?
      end
    end

    filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-#{website.name.parameterize}-bulk-product-export.csv"

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

    # puts uploaded
    puts 'Done'
  end
end
