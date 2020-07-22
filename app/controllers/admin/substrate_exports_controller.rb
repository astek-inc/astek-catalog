module Admin
  class SubstrateExportsController < Admin::BaseController

    def index
      @websites = Website.all
      @substrates = Substrate.where('display_description != ?', '')
      # respond_to do |format|
      #   format.json
      #   # render 'admin/substrate_exports/index.json.jbuilder'
      # end

    end

    def export_by_domain
      @website = Website.find_by(id: params[:website_id])
      @substrates = Substrate.for_domain(@website.domain)
    end

  end
end
