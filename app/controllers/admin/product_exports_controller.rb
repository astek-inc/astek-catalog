module Admin
  class ProductExportsController < Admin::BaseController

    include VariantHelper

    def index
      @websites = Website.all
    end

    def generate_csv
      collection = Collection.find(params[:collection_id])
      website = Website.find(params[:website_id])

      variants = collection.designs.map { |d| d.variants }.flatten
      csv_data = variants_to_csv variants, website.domain

      respond_to do |format|
        format.csv { send_data csv_data, type: 'text/csv; charset=utf-8; header=present', filename: "#{website.name.parameterize}-product-export-#{collection.name.parameterize}-#{Date.today}.csv" }
      end
    end

  end
end
