module Admin
  class DesignPropertiesController < Admin::BaseController

    before_action :get_design, :get_collection, :get_properties
    before_action :setup_property, only: :index

    def index
    end

    def destroy
      design_property = DesignProperty.find(params[:id])
      if design_property.destroy
        flash[:notice] = 'Property removed.'
      else
        flash[:notice] = 'Error removing property.'
      end
      redirect_to(action: 'index')
    end

    def assign
      @design.design_properties.clear

      params[:design][:design_properties_attributes].each do |index, data|
        property_id = Property.find_by(name: data[:property_name]).id
        @design.design_properties << DesignProperty.create!({ design_id: @design.id, property_id: property_id, value: data[:value] })
      end

      flash[:notice] = 'Properties updated.'
      redirect_to(action: 'index')
    end

    def update_row_order
      design_property = DesignProperty.find(params[:item_id])
      design_property.row_order_position = params[:row_order_position]
      design_property.save

      render nothing: true
    end

    private

    def get_design
      @design = Design.friendly.find(params[:design_id])
    end

    def get_collection
      @collection = @design.collection
    end

    def get_properties
      @properties = Property.pluck(:name)
    end

    def setup_property
      @design.design_properties.build
    end

    def design_property_params
      params.require(:design_property).permit(:design_id, :property_id, :value)
    end

  end
end
