namespace :db do
  desc "Generate redirects from old URL to new URL after a collection's designs have been given descriptive names instead of just SKUs"

  task collection_redirects: :environment do

    if !collection_name = ENV['COLLECTION']
      raise 'Collection not specified'
    end

    require 'csv'

    if collection = Collection.find_by(name: collection_name)
      puts "Getting designs for collection #{collection.name}"
      csv_data = CSV.generate(headers: true) do |csv|
        csv << ['Redirect from', 'Redirect to']
        collection.designs.each do |d|
          csv << ['/products/d-'+d.sku.parameterize, '/products/'+d.handle]
        end
      end

      filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-#{collection.name.parameterize}-redirects.csv"

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

      puts "Uploaded file #{filename} to S3. File available at https://product-data-export.s3-us-west-2.amazonaws.com/#{filename}."

    else

      puts "No collection found named #{collection_name}"

    end

    # puts uploaded
    puts 'Done'
  end

end
