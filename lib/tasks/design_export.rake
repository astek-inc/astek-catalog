require "#{Rails.root}/lib/admin/product_data_csv_generator.rb"
include Admin::ProductDataCsvGenerator

namespace :db do
  desc 'Export product information for a single design that is flagged to show on a given domain'
  task :design_export => :environment do

    if !domain = ENV['DOMAIN']
      raise 'Domain not specified'

    end

    if !skus = ENV['SKUS']
      raise 'No design SKU specified'
    end

    skus = skus.split(',').map { |i| i.strip }
    website = Website.find_by!(domain: domain)

    csv_data = ''
    skus.each do |sku|

      puts 'Getting product information for SKU '+ sku +' to export for '+domain
      
      design = Design.find_by(sku: sku)

      unless design.collection.websites.map { |w| w.domain }.include? domain
        raise design.name +' design is not flagged as available for the '+domain+' domain'
      end

      unless design.available?
        raise design.name +' design is not flagged as available'
      end

      puts 'Getting data for '+design.name
      csv_data += Admin::ProductDataCsvGenerator.product_data_csv design, domain, csv_data.empty?

    end

    if skus.length < 10
      skus_for_filename = skus.map { |s| s.downcase.gsub(/[^a-z0-9]/, '') }.join('-')
    else
      skus_for_filename = 'assorted-skus'
    end

    filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-#{website.name.parameterize}-product-export-#{skus_for_filename}.csv"

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
