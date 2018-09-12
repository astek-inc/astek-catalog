module Admin
  class VariantTearsheetsController < ApplicationController

    before_action :get_variant
    before_action :get_design, :get_collection, only: :show

    def show

    end

    def generate
      respond_to do |format|
        format.pdf do
          @variant.generate_tearsheet
          flash[:notice] = 'Tearsheet generated.'
          redirect_to(action: 'show')
        end
      end
    end

    private

    def get_variant
      @variant = Variant.friendly.find(params[:variant_id])
    end

    def get_design
      @design = @variant.design
    end

    def get_collection
      @collection = @design.collection
    end

  end
end
