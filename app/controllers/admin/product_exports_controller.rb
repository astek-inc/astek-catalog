module Admin
  class ProductExportsController < Admin::BaseController

    before_action :set_websites, only: [:export_by_collection, :export_by_design, :export_by_sku, :export_all]

    def export_by_collection
    end

    def export_by_design
    end

    def export_by_sku
    end

    def export_all
    end

    def generate_collection_csv
      CollectionExportJob.perform_later(params[:collection_id], params[:website_id], current_user)
      flash[:notice] = 'The collection has been queued for export. You will receive a notification by email when your CSV file is ready.'
      redirect_to(action: 'export_by_collection')
    end

    def generate_design_csv
      DesignExportJob.perform_later(params[:design_id], params[:website_id], current_user)
      flash[:notice] = 'The design has been queued for export. You will receive a notification by email when your CSV file is ready.'
      redirect_to(action: 'export_by_design')
    end

    def generate_skus_csv
      SkusExportJob.perform_later(params[:design_skus], params[:website_id], current_user)
      flash[:notice] = 'The designs have been queued for export. You will receive a notification by email when your CSV file is ready.'
      redirect_to(action: 'export_by_sku')
    end

    def generate_all_csv
      AllExportJob.perform_later(params[:website_id], current_user)
      flash[:notice] = 'The data has been queued for export. You will receive a notification by email when your CSV file is ready.'
      redirect_to(action: 'export_all')
    end

    private

    def set_websites
      @websites = Website.all
    end

  end
end
