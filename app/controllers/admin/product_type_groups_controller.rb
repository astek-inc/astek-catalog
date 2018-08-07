module Admin
  class ProductTypeGroupsController < BaseController

    def index
      @product_type_groups = ProductTypeGroup.rank(:row_order).page params[:page]
      @position_start = (@product_type_groups.current_page.present? ? @product_type_groups.current_page - 1 : 0) * @product_type_groups.limit_value
    end

    def new
      @product_type_group = ProductTypeGroup.new
    end

    def create
      @product_type_group = ProductTypeGroup.new(product_type_group_params)
      if @product_type_group.save
        flash[:notice] = 'Product type group created.'
        redirect_to(action: 'index')
      else
        if @product_type_group.errors.any?
          msg = @product_type_group.errors.full_messages.join(', ')
        else
          msg = 'Error creating product type.'
        end
        flash[:error] = msg
        render('new')
      end
    end

    def edit
      @product_type_group = ProductTypeGroup.find(params[:id])
    end

    def update
      @product_type_group = ProductTypeGroup.find(params[:id])
      if @product_type_group.update_attributes(product_type_group_params)
        flash[:notice] = 'Product type group updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def delete
      @product_type_group = ProductTypeGroup.find(params[:id])
    end

    def update_row_order
      @product_type_group = ProductTypeGroup.find(params[:item_id])
      @product_type_group.row_order_position = params[:row_order_position]
      @product_type_group.save

      render nothing: true
    end

    def destroy
      ProductTypeGroup.find(params[:id]).destroy
      flash[:notice] = 'Product type group destroyed.'
      redirect_to(action: 'index')
    end

    private

    def product_type_group_params
      params.require(:product_type_group).permit(:name, :description)
    end

  end

end
