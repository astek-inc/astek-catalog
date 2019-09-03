require "#{Rails.root}/lib/admin/fedex_crossborder_csv_generator.rb"

namespace :db do
  desc 'Export collection data for FedEx Crossborder service'
  task fedex_crossborder_collection_export: :environment do

    if !collection_name = ENV['COLLECTION']
      raise 'Collection not specified'
    end
    
    collection = Collection.find_by(name: collection_name)

    unless collection.websites.map { |w| w.domain }.include? 'astekhome.com'
      raise collection_name +' collection is not flagged as available for the '+domain+' domain'
    end

    puts 'Getting data for '+collection.name

    csv_data = ''
    collection.designs.available.each do |design|
      csv_data += ::Admin::FedexCrossborderCsvGenerator.fedex_crossborder_csv design, csv_data.empty?
    end

    filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-fedex-crossborder-product-data-#{collection.name.parameterize}.csv"

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
