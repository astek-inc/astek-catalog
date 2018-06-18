module Admin
  class SitesController < Admin::BaseController

    def index
      @sites = Site.all
    end

    def new
      @site = Site.new
    end

    def create
      @site = Site.new(site_params)
      if @site.save
        flash[:notice] = 'Site created.'
        redirect_to(action: 'index')
      else
        render('new')
      end
    end

    def edit
      @site = Site.find(params[:id])
    end

    def update
      @site = Site.find(params[:id])
      if @site.update_attributes(site_params)
        flash[:notice] = 'Site updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def delete
      @site = Site.find(params[:id])
    end

    def destroy
      Site.find(params[:id]).destroy
      flash[:notice] = "Site destroyed."
      redirect_to(action: 'index')
    end

    private

    def site_params
      params.require(:site).permit(:name, :domain)
    end

  end
end
