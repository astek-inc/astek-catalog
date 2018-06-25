module Admin
  class ProductTypesController < BaseController

    before_action :load_websites, only: [:new, :edit]

    def index
      @product_types = ProductType.rank(:row_order).page params[:page]
      @position_start = (@product_types.current_page.present? ? @product_types.current_page - 1 : 0) * @product_types.limit_value
    end

    def new
      @product_type = ProductType.new
    end

    def create
      @product_type = ProductType.new(product_type_params)
      if @product_type.save
        flash[:notice] = 'Product type created.'
        redirect_to(action: 'index')
      else
        render('new')
      end
    end

    def edit
      @product_type = ProductType.friendly.find(params[:id])
    end

    def update
      @product_type = ProductType.friendly.find(params[:id])
      if @product_type.update_attributes(product_type_params)
        flash[:notice] = 'Product type updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def delete
      @product_type = ProductType.friendly.find(params[:id])
    end

    def update_row_order
      @product_type = ProductType.find(params[:item_id])
      @product_type.row_order_position = params[:row_order_position]
      @product_type.save

      render nothing: true
    end

    def destroy
      ProductType.friendly.find(params[:id]).destroy
      flash[:notice] = 'Product type destroyed.'
      redirect_to(action: 'index')
    end

    private

    def load_websites
      @websites = Website.all
    end

    def product_type_params
      params.require(:product_type).permit(:name, :description, :keywords, :slug) #, image_attributes: [:file, :imageable_id, :image_type])
    end

  end

end
