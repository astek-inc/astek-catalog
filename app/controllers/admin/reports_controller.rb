module Admin
  class ReportsController < Admin::BaseController

    def digital_products_by_sku
    end

    def generate_digital_products_by_sku_csv
      DigitalProductsReportBySkuJob.perform_later(current_user)
      flash[:notice] = 'The report has been queued for export. You will receive a notification by email when your CSV file is ready.'
      redirect_to(action: 'digital_products_by_sku')
    end

  end
end
