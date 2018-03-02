module Admin
  class SubstratesController < Admin::BaseController

    before_action :set_substrate, only: [:edit, :update, :destroy]

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
        flash[:error] = 'Error creating substrate.'
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

      def substrate_params
        params.require(:substrate).permit(:name, :description, :keywords)
      end

  end
end
