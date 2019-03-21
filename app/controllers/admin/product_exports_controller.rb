module Admin
  class ProductExportsController < Admin::BaseController

    def index
      @websites = Website.all
    end

    def generate_csv
      collection = Collection.find(params[:collection_id])
      website = Website.find(params[:website_id])

      CollectionExportJob.perform_later(collection, website, current_user)

      flash[:notice] = 'The collection has been queued for export. You will receive a notification by email when your CSV file is ready.'
      redirect_to(action: 'index')
    end

  end
end
