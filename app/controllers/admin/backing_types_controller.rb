module Admin
  class BackingTypesController < BaseController

    before_action :set_backing_type, only: [:edit, :update, :destroy]

    def index
      @backing_types = BackingType.rank(:row_order).page params[:page]
      @position_start = (@backing_types.current_page.present? ? @backing_types.current_page - 1 : 0) * @backing_types.limit_value
    end

    def new
      @backing_type = BackingType.new
    end

    def create
      @backing_type = BackingType.new(backing_type_params)
      if @backing_type.save
        flash[:notice] = 'Product type created.'
        redirect_to(action: 'index')
      else
        if @backing_type.errors.any?
          msg = @backing_type.errors.full_messages.join(', ')
        else
          msg = 'Error creating backing type.'
        end
        flash[:error] = msg
        render('new')
      end
    end

    def edit
    end

    def update
      if @backing_type.update_attributes(backing_type_params)
        flash[:notice] = 'Product type updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def destroy
      @backing_type.destroy
      flash[:notice] = 'Product type removed.'
      redirect_to(action: 'index')
    end

    def update_row_order
      @backing_type = BackingType.find(params[:item_id])
      @backing_type.row_order_position = params[:row_order_position]
      @backing_type.save

      render nothing: true
    end

    private

    def set_backing_type
      @backing_type = BackingType.find(params[:id])
    end

    def backing_type_params
      params.require(:backing_type).permit(:name, :description)
    end

  end

end
