module Admin
  class SubstrateImagesController < Admin::BaseController

    before_action :get_substrate

    def index
    end

    def new
      @substrate_image = SubstrateImage.new
    end

    def create
      @substrate_image = SubstrateImage.new(substrate_image_params)
      if @substrate_image.save!
        flash[:notice] = 'Image added.'
        redirect_to(action: 'index')
      else
        flash[:alert] = 'Error adding image'
        render('new')
      end
    end

    def show
      @substrate_image = SubstrateImage.find(params[:id])
    end

    def destroy
      @substrate_image = SubstrateImage.find(params[:id])
      if @substrate_image.destroy!
        flash[:notice] = 'Image deleted.'
      else
        flash[:alert] = 'Error deleting image.'
      end
      redirect_to(action: 'index')
    end

    def update_row_order
      @substrate_image = SubstrateImage.find(params[:item_id])
      @substrate_image.row_order_position = params[:row_order_position]
      @substrate_image.save

      render nothing: true
    end

    private

    def get_substrate
      @substrate = Substrate.friendly.find(params[:substrate_id])
    end

    def substrate_image_params
      params.require(:substrate_image).permit(:file, :type, :owner_id)
    end

  end
end
