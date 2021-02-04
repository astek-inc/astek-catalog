module Admin
  class SubstratePrintImagesController < Admin::BaseController

    before_action :set_image, only: [:show, :destroy]
    before_action :set_substrate

    def index
    end

    def new
      @substrate_print_image = SubstratePrintImage.new
    end

    def create
      @substrate_print_image = SubstratePrintImage.new(substrate_print_image_params)
      if @substrate_print_image.save!
        flash[:notice] = 'Image added.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @substrate_print_image
        render('new')
      end
    end

    def show
    end

    def destroy
      if @substrate_print_image.destroy!
        flash[:notice] = 'Image deleted.'
      else
        flash[:error] = error_message @substrate_print_image
      end
      redirect_to(action: 'index')
    end

    def update_row_order
      @substrate_print_image = SubstratePrintImage.find(params[:item_id])
      @substrate_print_image.row_order_position = params[:row_order_position]
      @substrate_print_image.save

      head :ok
    end

    private

    def set_image
      @substrate_print_image = SubstratePrintImage.find(params[:id])
    end

    def set_substrate
      @substrate = Substrate.find(params[:substrate_id])
    end

    def substrate_print_image_params
      params.require(:substrate_print_image).permit(:file, :type, :owner_id)
    end

  end
end
