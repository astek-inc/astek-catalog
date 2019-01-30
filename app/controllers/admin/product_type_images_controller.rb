module Admin
  class ProductTypeImagesController < Admin::BaseController

    before_action :get_product_type

    def index
    end

    def new
      @product_type_image = ProductTypeImage.new
    end

    def create
      @product_type_image = ProductTypeImage.new(product_type_image_params)
      if @product_type_image.save!
        flash[:notice] = 'Image added.'
        redirect_to(action: 'index')
      else
        flash[:alert] = 'Error adding image'
        render('new')
      end
    end

    def show
      @product_type_image = ProductTypeImage.find(params[:id])
    end

    def destroy
      @product_type_image = Image.find(params[:id])
      if @product_type_image.destroy!
        flash[:notice] = 'Image deleted.'
      else
        flash[:alert] = 'Error deleting image.'
      end
      redirect_to(action: 'index')
    end

    def update_row_order
      @product_type_image = ProductTypeImage.find(params[:item_id])
      @product_type_image.row_order_position = params[:row_order_position]
      @product_type_image.save

      render nothing: true
    end

    private

    def get_product_type
      @product_type = ProductType.find(params[:product_type_id])
    end

    def product_type_image_params
      params.require(:product_type_image).permit(:file, :type, :owner_id)
    end

  end
end
