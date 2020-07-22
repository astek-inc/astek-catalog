module Admin
  class StylesController < Admin::BaseController

    before_action :set_style, only: [:edit, :update, :delete, :destroy]
    def index
      @styles = Style.all
    end

    def new
      @style = Style.new
    end

    def create
      @style = Style.new(style_params)
      if @style.save
        flash[:notice] = 'Style created.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @style
        render('new')
      end
    end

    def edit
    end

    def update
      if @style.update_attributes(style_params)
        flash[:notice] = 'Style updated.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @style
        render('edit')
      end
    end

    def delete
    end

    def destroy
      @style.destroy
      flash[:notice] = "Style removed."
      redirect_to(action: 'index')
    end

    private

    def set_style
      @style = Style.find(params[:id])
    end

    def style_params
      params.require(:style).permit(:name)
    end

  end
end
