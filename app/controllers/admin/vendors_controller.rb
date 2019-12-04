module Admin
  class VendorsController < Admin::BaseController

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
        if @vendor.errors.any?
          msg = @vendor.errors.full_messages.join(', ')
        else
          msg = 'Error creating vendor.'
        end
        flash[:error] = msg
        render('new')
      end
    end

    def edit
      @vendor = Vendor.find(params[:id])
    end

    def update
      @vendor = Vendor.find(params[:id])
      if @vendor.update_attributes(vendor_params)
        flash[:notice] = 'Vendor updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def delete
      @vendor = Vendor.find(params[:id])
    end

    def destroy
      Vendor.find(params[:id]).destroy
      flash[:notice] = "Vendor removed."
      redirect_to(action: 'index')
    end

    private

    def vendor_params
      params.require(:vendor).permit(:name, :description)
    end

  end
end
