require "#{Rails.root}/lib/admin/fedex_crossborder_csv_generator.rb"

namespace :db do
  desc 'Export collection data from a given category for FedEx Crossborder service'
  task fedex_crossborder_category_export: :environment do

    if !category_name = ENV['CATEGORY']
      raise 'Category not specified'
    end

    puts 'Getting product data from '+ category_name +' category to export'

    category = ProductCategory.find_by(name: category_name)

    csv_data = ''
    category.collections.for_domain('astekhome.com').each do |collection|
      puts 'Getting data for '+collection.name

      collection.designs.available.for_domain('astekhome.com').each do |design|
        if design.price.present? && design.country_id.present?
          csv_data += ::Admin::FedexCrossborderCsvGenerator.fedex_crossborder_csv design, csv_data.empty?
        end
      end

    end

    filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-fedex-crossborder-category-data-#{category.name.parameterize}.csv"

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
