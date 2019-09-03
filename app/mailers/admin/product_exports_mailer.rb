module Admin
  class ProductExportsMailer < ApplicationMailer

    def collection_notification_email
      @user = params[:user]
      @collection = params[:collection]
      @csv_url = params[:csv_url]
      mail(to: @user.email, subject: 'Collection product export complete')
    end

    def design_notification_email
      @user = params[:user]
      @design = params[:design]
      @csv_url = params[:csv_url]
      mail(to: @user.email, subject: 'Design product export complete')
    end

    def design_failure_email
      @user = params[:user]
      @design = params[:design]
      @error_message = params[:error_message]
      mail(to: @user.email, subject: 'Design product export failed')
    end

    def skus_notification_email
      @user = params[:user]
      @skus = params[:skus]
      @csv_url = params[:csv_url]
      @error_message = params[:error_message]
      mail(to: @user.email, subject: 'Product export by SKU complete')
    end

    def skus_failure_email
      @user = params[:user]
      @error_message = params[:error_message]
      mail(to: @user.email, subject: 'Product export by SKU failed')
    end

    def all_notification_email
      @user = params[:user]
      @website = params[:website]
      @csv_url = params[:csv_url]
      mail(to: @user.email, subject: 'Product export complete')
    end
  end
end
