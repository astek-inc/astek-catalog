# require "#{Rails.root}/lib/admin/substrate_information_json_generator.rb"

module Admin
  class SubstrateInformationExportsController < Admin::BaseController

    def index

    end

    def generate_json

      substrates = Substrate.where(display_on_public_sites: true)

      out = {}
      Substrate.where(display_on_public_sites: true).each do |s|
        handle = (s.display_name.present? ? s.display_name : s.name ).parameterize
        out[handle] = { name: (s.display_name.present? ? s.display_name : s.name ), description: s.display_description }
      end
      out.to_json

      # collection = Collection.find(params[:collection_id])
      #
      # csv_data = ''
      # collection.designs.each do |design|
      #   csv_data += ::Admin::OrderLimitsCsvGenerator.order_limits_csv design
      # end
      #
      # respond_to do |format|
      #   format.csv { send_data csv_data, type: 'text/csv; charset=utf-8; header=present', filename: "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}-order-limits-export-#{collection.name.parameterize}.csv" }
      # end
    end

  end
end
