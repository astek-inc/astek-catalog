module Admin
  class ProductTypesController < BaseController

    before_action :set_product_type, only: [:edit, :update, :destroy]
    before_action :set_product_categories, only: [:new, :edit]
    before_action :set_websites, only: [:index, :new, :edit]

    def index
      @product_types = ProductType.page params[:page]
    end

    def new
      @product_type = ProductType.new
    end

    def create
      @product_type = ProductType.new(product_type_params)
      if @product_type.save
        flash[:notice] = 'Product type created.'
        redirect_to(action: 'edit', id: @product_type.id)
      else
        flash[:error] = error_message @product_type
        render('new')
      end
    end

    def edit
    end

    def update
      if @product_type.update_attributes(product_type_params)
        flash[:notice] = 'Product type updated.'
        redirect_to(action: 'edit', id: @product_type.id)
      else
        flash[:error] = error_message @product_type
        render('edit')
      end
    end

    def destroy
      @product_type.destroy
      flash[:notice] = 'Product type removed.'
      redirect_to(action: 'index')
    end

    private

    def set_product_type
      @product_type = ProductType.find(params[:id])
    end

    def set_product_categories
      @product_categories = ProductCategory.all
    end

    def set_websites
      @websites = Website.all
    end

    def product_type_params
      params.require(:product_type).permit(:name, :description, :product_category_id, website_ids: [])
    end

  end

end
