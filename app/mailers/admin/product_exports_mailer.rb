module Admin
  class ProductExportsMailer < ApplicationMailer

    def notification_email
      @user = params[:user]
      @collection = params[:collection]
      @csv_url = params[:csv_url]
      mail(to: @user.email, subject: 'Product export complete')
    end
  end
end


# Admin::ProductExportsMailer.with(user: User.first, collection: Collection.first, csv_url: 'https://www.example.com/test').notification_email.deliver_now
