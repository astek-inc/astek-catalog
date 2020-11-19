require "#{Rails.root}/lib/admin/fedex_crossborder_csv_generator.rb"

namespace :db do
  desc 'Export product data for FedEx Crossborder service'
  task :fedex_crossborder_export => :environment do

    csv_data = ''
    Collection.for_domain('astekhome.com').each do |collection|
      puts 'Getting data for '+collection.name

      collection.designs.available.for_domain('astekhome.com').each do |design|
        if design.price.present? && design.price > 0 && design.country_id.present?
          csv_data += ::Admin::FedexCrossborderCsvGenerator.fedex_crossborder_csv design, csv_data.empty?
        end
      end
    end

    filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-fedex-crossborder-product-data.csv"

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
