require "#{Rails.root}/lib/admin/order_limits_csv_generator.rb"
# include Admin::OrderLimitsCsvGenerator

namespace :db do
  desc 'Export order limits for a set of designs specified by SKU'
  task design_order_limits_export: :environment do

    domain = 'astekhome.com'

    if !skus = ENV['SKUS']
      raise 'No design SKU specified'
    end

    puts 'Getting order limits information to export for '+domain

    skus = skus.split(',').map { |i| i.strip }
    website = Website.find_by!(domain: domain)

    designs = Design.where(sku: skus)

    csv_data = ''
    designs.each do |design|

      unless design.collection.websites.map { |w| w.domain }.include? domain
        raise design.name +' design is not flagged as available for the '+domain+' domain'
      end

      unless design.available?
        raise design.name +' design is not flagged as available'
      end

      puts 'Getting data for '+design.name
      csv_data += ::Admin::OrderLimitsCsvGenerator.order_limits_csv design
    end

    if skus.length < 10
      skus_for_filename = skus.map { |s| s.downcase.gsub(/[^a-z0-9]/, '') }.join('-')
    else
      skus_for_filename = 'assorted-skus'
    end

    filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-#{website.name.parameterize}-order-limits-export-#{skus_for_filename}.csv"

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
    puts 'Done'

  end
end
