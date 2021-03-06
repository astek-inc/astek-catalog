require "#{Rails.root}/lib/admin/tearsheet_generator.rb"

module Admin
  class VariantTearsheetsController < Admin::BaseController

    before_action :get_variant
    before_action :get_design, :get_collection, only: :show

    def show

    end

    def generate
      respond_to do |format|
        format.pdf do
          ::Admin::TearsheetGenerator.generate @variant
          flash[:notice] = 'Tearsheet generated.'
          redirect_to(action: 'show')
        end
      end
    end

    private

    def get_variant
      @variant = Variant.find(params[:variant_id])
    end

    def get_design
      @design = @variant.design
    end

    def get_collection
      @collection = @design.collection
    end

  end
end
