module Admin
  class VariantTypesController < Admin::BaseController

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
        render('new')
      end
    end

    def edit
      @variant_type = VariantType.find(params[:id])
    end

    def update
      @variant_type = VariantType.find(params[:id])
      if @variant_type.update_attributes(variant_type_params)
        flash[:notice] = 'Variant type updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def destroy
      VariantType.find(params[:id]).destroy
      flash[:notice] = 'Variant type destroyed.'
      redirect_to(action: 'index')
    end

    private

    def variant_type_params
      params.require(:variant_type).permit(:name)
    end

  end
end
