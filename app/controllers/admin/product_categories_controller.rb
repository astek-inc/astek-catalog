module Admin
  class ProductCategoriesController < BaseController

    def index
      @product_categories = ProductCategory.rank(:row_order).page params[:page]
      @position_start = (@product_categories.current_page.present? ? @product_categories.current_page - 1 : 0) * @product_categories.limit_value
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
        if @product_category.errors.any?
          msg = @product_category.errors.full_messages.join(', ')
        else
          msg = 'Error creating product type.'
        end
        flash[:error] = msg
        render('new')
      end
    end

    def edit
      @product_category = ProductCategory.find(params[:id])
    end

    def update
      @product_category = ProductCategory.find(params[:id])
      if @product_category.update_attributes(product_category_params)
        flash[:notice] = 'Product type group updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def delete
      @product_category = ProductCategory.find(params[:id])
    end

    def update_row_order
      @product_category = ProductCategory.find(params[:item_id])
      @product_category.row_order_position = params[:row_order_position]
      @product_category.save

      render nothing: true
    end

    def destroy
      ProductCategory.find(params[:id]).destroy
      flash[:notice] = 'Product type group destroyed.'
      redirect_to(action: 'index')
    end

    private

    def product_category_params
      params.require(:product_category).permit(:name, :description)
    end

  end

end
