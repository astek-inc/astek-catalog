module Admin
  class StylesController < Admin::BaseController

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
        if @style.errors.any?
          msg = @style.errors.full_messages.join(', ')
        else
          msg = 'Error creating style.'
        end
        flash[:error] = msg
        render('new')
      end
    end

    def edit
      @style = Style.find(params[:id])
    end

    def update
      @style = Style.find(params[:id])
      if @style.update_attributes(style_params)
        flash[:notice] = 'Style updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def delete
      @style = Style.find(params[:id])
    end

    def destroy
      Style.find(params[:id]).destroy
      flash[:notice] = "Style removed."
      redirect_to(action: 'index')
    end

    private

    def style_params
      params.require(:style).permit(:name)
    end

  end
end
