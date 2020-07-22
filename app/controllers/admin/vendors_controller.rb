module Admin
  class VendorsController < Admin::BaseController

    before_action :set_vendor, only: [:edit, :update, :delete, :destroy]

    def index
      @vendors = Vendor.all
    end

    def new
      @vendor = Vendor.new
    end

    def create
      @vendor = Vendor.new(vendor_params)
      if @vendor.save
        flash[:notice] = 'Vendor created.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @vendor
        render('new')
      end
    end

    def edit
    end

    def update
      if @vendor.update_attributes(vendor_params)
        flash[:notice] = 'Vendor updated.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @vendor
        render('edit')
      end
    end

    def delete
    end

    def destroy
      @vendor.destroy
      flash[:notice] = "Vendor removed."
      redirect_to(action: 'index')
    end

    private

    def set_vendor
      @vendor = Vendor.find(params[:id])
    end

    def vendor_params
      params.require(:vendor).permit(:name, :description)
    end

  end
end
