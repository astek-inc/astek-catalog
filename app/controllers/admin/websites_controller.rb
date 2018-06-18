module Admin
  class WebsitesController < Admin::BaseController

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
        render('new')
      end
    end

    def edit
      @website = Website.find(params[:id])
    end

    def update
      @website = Website.find(params[:id])
      if @website.update_attributes(website_params)
        flash[:notice] = 'Website updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def delete
      @website = Website.find(params[:id])
    end

    def destroy
      Website.find(params[:id]).destroy
      flash[:notice] = "Website destroyed."
      redirect_to(action: 'index')
    end

    private

    def website_params
      params.require(:website).permit(:name, :domain)
    end

  end
end
