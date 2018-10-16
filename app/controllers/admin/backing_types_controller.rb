module Admin
  class BackingTypesController < BaseController

    before_action :set_backing_type, only: [:edit, :update, :destroy]

    def index
      @backing_types = BackingType.page params[:page]
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

    private

    def set_backing_type
      @backing_type = BackingType.find(params[:id])
    end

    def backing_type_params
      params.require(:backing_type).permit(:name, :description)
    end

  end

end
