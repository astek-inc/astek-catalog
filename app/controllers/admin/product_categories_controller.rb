module Admin
  class ProductCategoriesController < BaseController

    before_action :set_product_category, only: [:edit, :update, :delete]

    def index
      @product_categories = ProductCategory.page params[:page]
    end

    def new
      @product_category = ProductCategory.new
    end

    def create
      @product_category = ProductCategory.new(product_category_params)
      if @product_category.save
        flash[:notice] = 'Product type group created.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @product_category
        render('new')
      end
    end

    def edit
    end

    def update
      if @product_category.update_attributes(product_category_params)
        flash[:notice] = 'Product type group updated.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @product_category
        render('edit')
      end
    end

    def delete
    end

    def destroy
      ProductCategory.find(params[:id]).destroy
      flash[:notice] = 'Product type group removed.'
      redirect_to(action: 'index')
    end

    private

    def product_category_params
      params.require(:product_category).permit(:name, :description)
    end

    def set_product_category
      @product_category = ProductCategory.find(params[:id])
    end

  end

end
