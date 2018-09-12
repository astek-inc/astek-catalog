module Admin
  class SubstratesController < Admin::BaseController

    before_action :set_substrate, only: [:edit, :update, :destroy]
    before_action :set_substrate_categories, only: [:new, :edit]

    def index
      @substrates = Substrate.rank(:row_order).page params[:page]
      @position_start = (@substrates.current_page.present? ? @substrates.current_page - 1 : 0) * @substrates.limit_value
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
        if @substrate.errors.any?
          msg = @substrate.errors.full_messages.join(', ')
        else
          msg = 'Error creating substrate.'
        end
        flash[:error] = msg
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
        flash[:error] = 'Error updating substrate.'
        render('edit')
      end
    end

    def destroy
      @substrate.destroy
    end

    private

    def set_substrate
      @substrate = Substrate.friendly.find(params[:id])
    end

    def set_substrate_categories
      @substrate_categories = SubstrateCategory.all
    end

    def substrate_params
      params.require(:substrate).permit(:name, :description, :keywords, :backing_type_id, substrate_category_ids: [])
    end

  end
end
