module Admin
  class SubstratesController < Admin::BaseController

    before_action :set_substrate, only: [:edit, :update, :destroy]
    before_action :set_substrate_categories, :set_websites, only: [:new, :create, :edit, :update]

    def index
      @substrates = Substrate.page params[:page]
    end

    def new
      @substrate = Substrate.new
    end

    def create
      @substrate = Substrate.new(substrate_params)
      if @substrate.save
        flash[:notice] = 'Substrate created.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @substrate
        render('new')
      end
    end

    def edit
    end

    def update
      if @substrate.update(substrate_params)
        flash[:notice] = 'Substrate updated.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @substrate
        render('edit')
      end
    end

    def destroy
      @substrate.destroy
      flash[:notice] = 'Substrate removed.'
      redirect_to(action: 'index')
    end

    private

    def set_substrate
      @substrate = Substrate.find(params[:id])
    end

    def set_substrate_categories
      @substrate_categories = SubstrateCategory.all
    end

    def set_websites
      @websites = Website.all
    end

    def substrate_params
      params.require(:substrate).permit(
          :name, :description, :display_name, :display_description, :keywords, :backing_type_id,
          :default_custom_material_group, :custom_material_surcharge, :weight_per_square_foot, substrate_category_ids: [], website_ids: []
      )
    end

  end
end
