module Admin
  class ReportsMailer < ApplicationMailer

    def digital_products_by_sku_notification_email
      @user = params[:user]
      @csv_url = params[:csv_url]
      mail(to: @user.email, subject: 'Report complete')
    end

  end
end
