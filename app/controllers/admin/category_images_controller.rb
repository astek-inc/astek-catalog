module Admin
  class CategoryImagesController < Admin::BaseController

    before_action :get_category

    def index
    end

    def new
      @category_image = CategoryImage.new
    end

    def create
      @category_image = CategoryImage.new(category_image_params)
      if @category_image.save!
        flash[:notice] = 'Image added.'
        redirect_to(action: 'index')
      else
        flash[:alert] = 'Error adding image'
        render('new')
      end
    end

    def show
      @category_image = CategoryImage.find(params[:id])
    end

    def destroy
      @category_image = Image.find(params[:id])
      if @category_image.destroy!
        flash[:notice] = 'Image deleted.'
      else
        flash[:alert] = 'Error deleting image.'
      end
      redirect_to(action: 'index')
    end

    def update_row_order
      @category_image = CategoryImage.find(params[:item_id])
      @category_image.row_order_position = params[:row_order_position]
      @category_image.save

      render nothing: true
    end

    private

    def get_category
      @category = Category.friendly.find(params[:category_id])
    end

    def category_image_params
      params.require(:category_image).permit(:file, :type, :owner_id)
    end

  end
end
