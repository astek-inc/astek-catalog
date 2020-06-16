module Admin
  class VariantSubstratesController < Admin::BaseController

    before_action :set_variant_substrate, except: [:index, :new, :create]
    before_action :set_variant, :set_design, :set_collection, :set_substrates, :set_websites, except: [:destroy]
    before_action :set_substrates, except: [:index, :destroy]

    def index
      @variant_substrates = VariantSubstrate.where(variant_id: params[:variant_id])
    end

    def new
      @variant_substrate = VariantSubstrate.new
      @variant_substrate.websites = @variant.websites
    end

    def create
      @variant_substrate = VariantSubstrate.new(variant_substrate_params)
      if @variant_substrate.save
        flash[:notice] = 'Substrate added.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @variant_substrate
        render('new')
      end
    end

    def edit

    end

    def update
      if @variant_substrate.update(variant_substrate_params)
        flash[:notice] = 'Substrate updated.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @variant_substrate
        render('edit')
      end
    end

    def destroy
      @variant_substrate.destroy
      flash[:notice] = 'Substrate removed.'
      redirect_to(action: 'index')
    end

    private

    def set_variant_substrate
      @variant_substrate = VariantSubstrate.find(params[:id])
    end

    def set_variant
      @variant = Variant.find(params[:variant_id])
    end

    def set_design
      @design = @variant.design
    end

    def set_collection
      @collection = @design.collection
    end

    def set_substrates
      @substrates = Substrate.all
    end

    def set_websites
      @websites = Website.all
    end

    def variant_substrate_params
      params.require(:variant_substrate).permit(:variant_id, :substrate_id, website_ids: [])
    end

  end
end
