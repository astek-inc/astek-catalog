module Admin
  class SubstrateExportsController < Admin::BaseController

    def index

      @substrates = Substrate.where('display_description != ?', '')
      # respond_to do |format|
      #   format.json
      #   # render 'admin/substrate_exports/index.json.jbuilder'
      # end

    end

  end
end
