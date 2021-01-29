module Admin
  class VariantSwatchImagesController < Admin::BaseController

    before_action :set_image, only: [:show, :destroy]
    before_action :set_variant, :set_design, :set_collection

    def index
    end

    def new
      @variant_swatch_image = VariantSwatchImage.new
    end

    def create
      @variant_swatch_image = VariantSwatchImage.new(variant_swatch_image_params)
      if @variant_swatch_image.save!
        flash[:notice] = 'Image added.'
        redirect_to(action: 'index')
      else
        flash[:alert] = 'Error adding image'
        render('new')
      end
    end

    def show
      @variant_swatch_image = VariantSwatchImage.find(params[:id])
    end

    def destroy
      if @variant_swatch_image.destroy!
        flash[:notice] = 'Image deleted.'
      else
        flash[:alert] = 'Error deleting image.'
      end
      redirect_to(action: 'index')
    end

    def update_row_order
      @variant_swatch_image = VariantSwatchImage.find(params[:item_id])
      @variant_swatch_image.row_order_position = params[:row_order_position]
      @variant_swatch_image.save

      head :ok
    end

    private

    def set_image
      @variant_swatch_image = VariantSwatchImage.find(params[:id])
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

    def variant_swatch_image_params
      params.require(:variant_swatch_image).permit(:file, :type, :owner_id)
    end

  end
end
