module Admin
  class VariantImagesController < Admin::BaseController

    before_action :get_variant, :get_design, :get_collection

    def index
    end

    def new
      @variant_image = VariantImage.new
    end

    def create
      @variant_image = VariantImage.new(variant_image_params)
      if @variant_image.save!
        flash[:notice] = 'Image added.'
        redirect_to(action: 'index')
      else
        flash[:alert] = 'Error adding image'
        render('new')
      end
    end

    def show
      @variant_image = VariantImage.find(params[:id])
    end

    def destroy
      @variant_image = VariantImage.find(params[:id])
      if @variant_image.destroy!
        flash[:notice] = 'Image deleted.'
      else
        flash[:alert] = 'Error deleting image.'
      end
      redirect_to(action: 'index')
    end

    def update_row_order
      @variant_image = VariantImage.find(params[:item_id])
      @variant_image.row_order_position = params[:row_order_position]
      @variant_image.save

      render nothing: true
    end

    private

    def get_variant
      @variant = Variant.find(params[:variant_id])
    end

    def get_design
      @design = @variant.design
    end

    def get_collection
      @collection = @design.collection
    end

    def variant_image_params
      params.require(:variant_image).permit(:file, :type, :owner_id)
    end

  end
end
