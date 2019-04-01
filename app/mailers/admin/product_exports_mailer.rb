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

    def skus_notification_email
      @user = params[:user]
      @skus = params[:skus]
      @csv_url = params[:csv_url]
      mail(to: @user.email, subject: 'Product export complete')
    end

    def all_notification_email
      @user = params[:user]
      @website = params[:website]
      @csv_url = params[:csv_url]
      mail(to: @user.email, subject: 'Product export complete')
    end
  end
end
