module Admin
  class VariantInstallImagesController < Admin::BaseController

    before_action :set_image, only: [:show, :edit, :update, :destroy]
    before_action :set_variant, :set_design, :set_collection, :set_websites

    def index
    end

    def new
      @variant_install_image = VariantInstallImage.new
      @variant_install_image.websites = @variant.websites
    end

    def create
      @variant_install_image = VariantInstallImage.new(variant_install_image_params)
      if @variant_install_image.save!
        flash[:notice] = 'Image added.'
        redirect_to(action: 'index')
      else
        flash[:alert] = 'Error adding image'
        render('new')
      end
    end

    def show

    end

    def edit

    end

    def update
      if @variant_install_image.update(variant_install_image_params)
        flash[:notice] = 'Image updated.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @variant_install_image
        render('edit')
      end
    end

    def destroy
      if @variant_install_image.destroy!
        flash[:notice] = 'Image removed.'
      else
        flash[:alert] = 'Error removing image.'
      end
      redirect_to(action: 'index')
    end

    def update_row_order
      @variant_install_image = VariantInstallImage.find(params[:item_id])
      @variant_install_image.row_order_position = params[:row_order_position]
      @variant_install_image.save

      head :ok
    end

    private

    def set_image
      @variant_install_image = VariantInstallImage.find(params[:id])
    end

    def set_variant
      @variant = Variant.find(params[:variant_id])
    end

    def set_design
      @design = @variant.design
    end

    def set_collection
      @collection = @design.collection
    end

    def set_websites
      @websites = Website.all
    end

    def variant_install_image_params
      params.require(:variant_install_image).permit(:file, :type, :owner_id, website_ids: [])
    end

  end
end
