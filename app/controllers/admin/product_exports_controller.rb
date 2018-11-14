require "#{Rails.root}/lib/admin/product_data_csv_generator.rb"

module Admin
  class ProductExportsController < Admin::BaseController

    include ProductDataCsvGenerator

    def index
      @websites = Website.all
    end

    def generate_csv
      collection = Collection.find(params[:collection_id])
      website = Website.find(params[:website_id])


      csv_data = ''
      collection.designs.available.each do |design|
        csv_data += product_data_csv design, website.domain, csv_data.empty?
      end

      respond_to do |format|
        format.csv { send_data csv_data, type: 'text/csv; charset=utf-8; header=present', filename: "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-#{website.name.parameterize}-product-export-#{collection.name.parameterize}.csv" }
      end
    end

  end
end
