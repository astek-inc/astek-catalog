module Admin
  class ProductExportsController < Admin::BaseController

    before_action :set_websites, only: [:shopify_export_by_collection, :shopify_export_by_design, :shopify_export_by_sku, :shopify_export_all]
    before_action :set_website_id, only: [:fedex_export_by_collection, :fedex_export_by_design, :fedex_export_by_sku, :fedex_export_all]

    def shopify_export_by_collection
    end

    def shopify_export_by_design
    end

    def shopify_export_by_sku
    end

    def shopify_export_all
    end

    def fedex_export_by_collection
    end

    def fedex_export_by_design
    end

    def fedex_export_by_sku
    end

    def fedex_export_all
    end

    def generate_shopify_collection_csv
      ShopifyCollectionExportJob.perform_later(params[:collection_id], params[:website_id], current_user)
      flash[:notice] = 'The collection has been queued for export. You will receive a notification by email when your CSV file is ready.'
      redirect_to(action: 'shopify_export_by_collection')
    end

    def generate_shopify_design_csv
      ShopifyDesignExportJob.perform_later(params[:design_id], params[:website_id], current_user)
      flash[:notice] = 'The design has been queued for export. You will receive a notification by email when your CSV file is ready.'
      redirect_to(action: 'shopify_export_by_design')
    end

    def generate_shopify_skus_csv
      ShopifySkusExportJob.perform_later(params[:design_skus], params[:website_id], current_user)
      flash[:notice] = 'The designs have been queued for export. You will receive a notification by email when your CSV file is ready.'
      redirect_to(action: 'shopify_export_by_sku')
    end

    def generate_shopify_all_csv
      ShopifyAllExportJob.perform_later(params[:website_id], current_user)
      flash[:notice] = 'The data has been queued for export. You will receive a notification by email when your CSV file is ready.'
      redirect_to(action: 'shopify_export_all')
    end

    def generate_fedex_collection_csv
      FedexCollectionExportJob.perform_later(params[:collection_id], current_user)
      flash[:notice] = 'The collection has been queued for export. You will receive a notification by email when your CSV file is ready.'
      redirect_to(action: 'fedex_export_by_collection')
    end

    def generate_fedex_design_csv
      FedexDesignExportJob.perform_later(params[:design_id], current_user)
      flash[:notice] = 'The design has been queued for export. You will receive a notification by email when your CSV file is ready.'
      redirect_to(action: 'fedex_export_by_design')
    end

    def generate_fedex_skus_csv
      FedexSkusExportJob.perform_later(params[:design_skus], current_user)
      flash[:notice] = 'The designs have been queued for export. You will receive a notification by email when your CSV file is ready.'
      redirect_to(action: 'fedex_export_by_sku')
    end

    def generate_fedex_all_csv
      FedexAllExportJob.perform_later(current_user)
      flash[:notice] = 'The data has been queued for export. You will receive a notification by email when your CSV file is ready.'
      redirect_to(action: 'fedex_export_all')
    end

    private

    def set_websites
      @websites = Website.all
    end

    def set_website_id
      @website_id = Website.find_by(domain: 'astekhome.com').id
    end

  end
end
