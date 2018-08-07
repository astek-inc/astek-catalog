module Admin
  class ProductTypesController < BaseController

    before_action :set_websites, :set_product_type_groups, only: [:new, :edit]

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
        if @product_type.errors.any?
          msg = @product_type.errors.full_messages.join(', ')
        else
          msg = 'Error creating product type.'
        end
        flash[:error] = msg
        render('new')
      end
    end

    def edit
      @product_type = ProductType.find(params[:id])
    end

    def update
      @product_type = ProductType.find(params[:id])
      if @product_type.update_attributes(product_type_params)
        flash[:notice] = 'Product type updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def delete
      @product_type = ProductType.find(params[:id])
    end

    def update_row_order
      @product_type = ProductType.find(params[:item_id])
      @product_type.row_order_position = params[:row_order_position]
      @product_type.save

      render nothing: true
    end

    def destroy
      ProductType.find(params[:id]).destroy
      flash[:notice] = 'Product type destroyed.'
      redirect_to(action: 'index')
    end

    private

    def set_websites
      @websites = Website.all
    end

    def set_product_type_groups
      @product_type_groups = ProductTypeGroup.rank(:row_order)
    end

    def product_type_params
      params.require(:product_type).permit(:name, :description, :product_type_group_id)
    end

  end

end
