module Admin
  class PropertiesController < Admin::BaseController

    before_action :set_property, only: [:edit, :update, :destroy]

    def index
      @properties = Property.all
    end

    def new
      @property = Property.new
    end

    def create
      @property = Property.new(property_params)
      if @property.save
        flash[:notice] = 'Property created.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @property
        render('new')
      end
    end

    def edit
    end

    def update
      if @property.update_attributes(property_params)
        flash[:notice] = 'Property updated.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @property
        render('edit')
      end
    end

    def destroy
      @property.destroy
      flash[:notice] = 'Property removed.'
      redirect_to(action: 'index')
    end

    private

    def set_property
      @property = Property.find(params[:id])
    end

    def property_params
      params.require(:property).permit(:name, :presentation)
    end

  end
end
