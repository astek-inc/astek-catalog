module Admin
  class PropertiesController < Admin::BaseController

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
        if @property.errors.any?
          msg = @property.errors.full_messages.join(', ')
        else
          msg = 'Error creating property.'
        end
        flash[:error] = msg
        render('new')
      end
    end

    def edit
      @property = Property.find(params[:id])
    end

    def update
      @property = Property.find(params[:id])
      if @property.update_attributes(property_params)
        flash[:notice] = 'Property updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def delete
      @property = Property.find(params[:id])
    end

    def destroy
      Property.find(params[:id]).destroy
      flash[:notice] = "Property destroyed."
      redirect_to(action: 'index')
    end

    private

    def property_params
      params.require(:property).permit(:name, :presentation, :klass_scope)
    end

  end
end
