module Admin
  class ColorsController < Admin::BaseController

    before_action :set_color, only: [:edit, :update, :destroy]

    def index
      @colors = Color.rank(:row_order).page params[:page]
      @position_start = (@colors.current_page.present? ? @colors.current_page - 1 : 0) * @colors.limit_value
    end

    def new
      @color = Color.new
    end

    def create
      @color = Color.new(color_params)
      if @color.save
        flash[:notice] = 'Color created.'
        redirect_to(action: 'index')
      else
        if @color.errors.any?
          msg = @color.errors.full_messages.join(', ')
        else
          msg = 'Error creating color.'
        end
        flash[:error] = msg
        render('new')
      end
    end

    def edit
    end

    def update
      if @color.update(color_params)
        flash[:notice] = 'Color updated.'
        redirect_to(action: 'index')
      else
        if @color.errors.any?
          msg = @color.errors.full_messages.join(', ')
        else
          msg = 'Error updating color.'
        end
        flash[:error] = msg
        render('edit')
      end
    end

    def update_row_order
      @color = Color.find(params[:item_id])
      @color.row_order_position = params[:row_order_position]
      @color.save

      render nothing: true
    end

    def destroy
      @color.destroy
    end

    private

    def set_color
      @color = Color.friendly.find(params[:id])
    end

    def color_params
      params.require(:color).permit(:name, :slug)
    end

  end
end
