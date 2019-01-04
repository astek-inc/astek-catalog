require "#{Rails.root}/lib/admin/product_data_csv_generator.rb"
include Admin::ProductDataCsvGenerator

namespace :db do
  desc 'Export product information for a single design that is flagged to show on a given domain'
  task :design_export => :environment do

    if !domain = ENV['DOMAIN']
      raise 'Domain not specified'

    end

    if !sku = ENV['SKU']
      raise 'Design SKU not specified'
    end

    puts 'Getting product information for SKU '+ sku +' to export for '+domain

    website = Website.find_by!(domain: domain)
    design = Design.find_by(sku: sku)

    unless design.collection.websites.map { |w| w.domain }.include? domain
      raise design.name +' design is not flagged as available for the '+domain+' domain'
    end

    unless design.available?
      raise design.name +' design is not flagged as available'
    end

    csv_data = ''
    puts 'Getting data for '+design.name
    csv_data += Admin::ProductDataCsvGenerator.product_data_csv design, domain, csv_data.empty?

    filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-#{website.name.parameterize}-product-export-#{design.name.parameterize}.csv"

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
