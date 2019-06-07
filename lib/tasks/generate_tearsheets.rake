require "#{Rails.root}/lib/admin/tearsheet_generator.rb"

namespace :db do
  desc "Generate tearsheets for a design's variants"
  task generate_tearsheets: :environment do

    if !collection_name = ENV['COLLECTION']
      raise 'Collection not specified'
    end

    collection = Collection.find_by(name: collection_name)

    if collection.product_category.name != 'Digital'
      raise 'Non-digital collections do not have tearsheets'
    end

    puts 'Generating tearsheets for collection '+collection.name

    collection.designs.each do |design|
      puts 'Generating tearsheets for design '+design.name
      design.variants.each do |variant|
        ::Admin::TearsheetGenerator.generate variant
        puts 'Tearsheet generated for variant '+variant.name
      end
    end

  end
end
