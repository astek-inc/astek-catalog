class Admin::ProductImportsMailer < ApplicationMailer

  def import_complete_email
    @user = params[:user]
    @csv_url = params[:csv_url]
    @collection_name = params[:collection_name]
    mail(to: @user.email, subject: 'Product import from CSV file complete')
  end

  def import_error_email
    @user = params[:user]
    @error_message = params[:error_message]
    @csv_url = params[:csv_url]
    @item = params[:item]
    mail(to: @user.email, subject: 'Error importing products from CSV file')
  end

end
