require "#{Rails.root}/lib/admin/shopify_design_data_csv_generator.rb"
require "#{Rails.root}/lib/admin/shopify_subcollection_data_csv_generator.rb"

# include Admin::ProductDataCsvGenerator

namespace :db do
  desc 'Export a collection of products that are flagged to show on a given domain'
  task :category_export => :environment do

    if !domain = ENV['DOMAIN']
      raise 'Domain not specified'

    end

    if !category_name = ENV['CATEGORY']
      raise 'Category not specified'
    end

    puts 'Getting product information from '+ category_name +' category to export for '+domain

    website = Website.find_by!(domain: domain)
    category = ProductCategory.find_by(name: category_name)

    csv_data = ''
    category.collections.each do |collection|
      next unless collection.websites.map { |w| w.domain }.include? domain

      puts 'Getting data for '+collection.name
      collection.designs.available.unsubcollected.each do |design|
        csv_data += ::Admin::ShopifyDesignDataCsvGenerator.product_data_csv design, domain, csv_data.empty?
      end

      collection.subcollections.each do |subcollection|
        csv_data += ::Admin::ShopifySubcollectionDataCsvGenerator.product_data_csv subcollection, domain, csv_data.empty?
      end
    end

    filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-#{website.name.parameterize}-product-export-#{category.name.parameterize}.csv"

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
