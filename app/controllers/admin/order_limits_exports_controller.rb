require "#{Rails.root}/lib/admin/order_limits_csv_generator.rb"

module Admin
  class OrderLimitsExportsController < Admin::BaseController

    include OrderLimitsCsvGenerator

    def index
      @website_id = Website.find_by(domain: 'astekhome.com').id
    end

    def generate_csv

      collection = Collection.find(params[:collection_id])

      csv_data = ''
      collection.designs.each do |design|
        csv_data += order_limits_csv design
      end

      respond_to do |format|
        format.csv { send_data csv_data, type: 'text/csv; charset=utf-8; header=present', filename: "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-order-limits-export-#{collection.name.parameterize}.csv" }
      end
    end

  end
end
