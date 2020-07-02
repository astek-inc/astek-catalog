module Admin
  class ColorsController < Admin::BaseController

    before_action :set_color, only: [:edit, :update, :destroy]

    def index
      @colors = Color.page params[:page]
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
        flash[:error] = error_message @color
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
        flash[:error] = error_message @color
        render('edit')
      end
    end

    def destroy
      @color.destroy
      flash[:notice] = 'Color removed.'
      redirect_to(action: 'index')
    end

    private

    def set_color
      @color = Color.find(params[:id])
    end

    def color_params
      params.require(:color).permit(:name)
    end

  end
end
