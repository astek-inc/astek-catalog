require "#{Rails.root}/lib/admin/product_subcollection_data_csv_generator.rb"

namespace :db do
  desc 'Export product information for a subcollection for a given domain'
  task :subcollection_export => :environment do

    if !domain = ENV['DOMAIN']
      raise 'Domain not specified'
    end

    if !id = ENV['ID']
      raise 'No subcollection ID specified'
    end

    website = Website.find_by!(domain: domain)

    csv_data = ''


      puts 'Getting subcollection information for ID '+ id +' to export for '+domain

      subcollection = Subcollection.find(id)

      unless subcollection.collection.websites.map { |w| w.domain }.include? domain
        raise subcollection.name +' subcollection is not flagged as available for the '+domain+' domain'
      end

      # subcollection.designs.each do |design|
      #   unless design.available?
      #     raise design.name +' design is not flagged as available'
      #   end
      #
      #   puts 'Getting data for '+design.name
        csv_data += ::Admin::ProductSubcollectionDataCsvGenerator.product_data_csv subcollection, domain, csv_data.empty?
      # end



    # puts csv_data

    # if skus.length < 10
    #   skus_for_filename = skus.map { |s| s.downcase.gsub(/[^a-z0-9]/, '') }.join('-')
    # else
    #   skus_for_filename = 'assorted-skus'
    # end
    #
    filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-#{website.name.parameterize}-product-export-subcollection-#{id}.csv"

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
