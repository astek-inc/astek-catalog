module Admin
  class VariantTypesController < Admin::BaseController

    before_action :set_variant_type, only: [:edit, :update, :destroy]

    def index
      @variant_types = VariantType.all
    end

    def new
      @variant_type = VariantType.new
    end

    def create
      @variant_type = VariantType.new(variant_type_params)
      if @variant_type.save
        flash[:notice] = 'Variant type created.'
        redirect_to(action: 'index')
      else
        if @variant_type.errors.any?
          msg = @variant_type.errors.full_messages.join(', ')
        else
          msg = 'Error creating variant type.'
        end
        flash[:error] = msg
        render('new')
      end
    end

    def edit
    end

    def update
      if @variant_type.update_attributes(variant_type_params)
        flash[:notice] = 'Variant type updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def destroy
      @variant_type.destroy
      flash[:notice] = 'Variant type removed.'
      redirect_to(action: 'index')
    end

    private

    def set_variant_type
      @variant_type = VariantType.find(params[:id])
    end

    def variant_type_params
      params.require(:variant_type).permit(:name)
    end

  end
end
