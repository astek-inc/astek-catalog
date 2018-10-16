module Admin
  class WebsitesController < Admin::BaseController

    before_action :set_website, only: [:edit, :update, :delete, :destroy]

    def index
      @websites = Website.all
    end

    def new
      @website = Website.new
    end

    def create
      @website = Website.new(website_params)
      if @website.save
        flash[:notice] = 'Website created.'
        redirect_to(action: 'index')
      else
        if @website.errors.any?
          msg = @website.errors.full_messages.join(', ')
        else
          msg = 'Error creating website.'
        end
        flash[:error] = msg
        render('new')
      end
    end

    def edit
    end

    def update
      if @website.update_attributes(website_params)
        flash[:notice] = 'Website updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def delete
    end

    def destroy
      @website.destroy
      flash[:notice] = "Website removed."
      redirect_to(action: 'index')
    end

    private

    def set_website
      @website = Website.find(params[:id])
    end

    def website_params
      params.require(:website).permit(:name, :domain)
    end

  end
end
