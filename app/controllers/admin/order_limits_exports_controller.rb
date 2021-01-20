require "#{Rails.root}/lib/admin/order_limits_csv_generator.rb"

module Admin
  class OrderLimitsExportsController < Admin::BaseController

    before_action :set_website_id, only: [:export_by_collection, :export_by_design]

    # def index
    #
    # end

    def export_by_collection

    end

    def export_by_design

    end

    def generate_design_csv
      design = Design.find(params[:design_id])
      csv_data = ::Admin::OrderLimitsCsvGenerator.order_limits_csv design

      respond_to do |format|
        format.csv { send_data csv_data, type: 'text/csv; charset=utf-8; header=present', filename: "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-order-limits-export-#{design.name.parameterize}.csv" }
      end
    end

    def generate_collection_csv

      collection = Collection.find(params[:collection_id])

      csv_data = ''
      collection.designs.available.for_domain('astekhome.com').each do |design|
        csv_data += ::Admin::OrderLimitsCsvGenerator.order_limits_csv design
      end

      respond_to do |format|
        format.csv { send_data csv_data, type: 'text/csv; charset=utf-8; header=present', filename: "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-order-limits-export-#{collection.name.parameterize}.csv" }
      end
    end

    private

    def set_website_id
      @website_id = Website.find_by(domain: 'astekhome.com').id
    end

  end
end
