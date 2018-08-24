require "#{Rails.root}/app/helpers/admin/variant_helper.rb"
include Admin::VariantHelper

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

      collection.designs.each do |design|
        csv_data += variants_to_csv design, domain, csv_data.empty?
      end
    end

    File.open("#{Rails.root}/tmp/#{website.name.parameterize}-bulk-export-#{Date.today}.csv", 'w+') do |f|
      f.write(csv_data)
    end

    puts 'Done'
  end
end
