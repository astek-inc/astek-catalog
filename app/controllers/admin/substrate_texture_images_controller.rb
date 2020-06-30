module Admin
  class SubstrateTextureImagesController < Admin::BaseController

    before_action :set_image, only: [:show, :destroy]
    before_action :set_substrate

    def index
    end

    def new
      @substrate_texture_image = SubstrateTextureImage.new
    end

    def create
      @substrate_texture_image = SubstrateTextureImage.new(substrate_texture_image_params)
      if @substrate_texture_image.save!
        flash[:notice] = 'Image added.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @substrate_texture_image
        render('new')
      end
    end

    def show
    end

    def destroy
      if @substrate_texture_image.destroy!
        flash[:notice] = 'Image deleted.'
      else
        flash[:error] = error_message @substrate_texture_image
      end
      redirect_to(action: 'index')
    end

    def update_row_order
      @substrate_texture_image = SubstrateTextureImage.find(params[:item_id])
      @substrate_texture_image.row_order_position = params[:row_order_position]
      @substrate_texture_image.save

      render nothing: true
    end

    private

    def set_image
      @substrate_texture_image = SubstrateTextureImage.find(params[:id])
    end

    def set_substrate
      @substrate = Substrate.find(params[:substrate_id])
    end

    def substrate_texture_image_params
      params.require(:substrate_texture_image).permit(:file, :type, :owner_id)
    end

  end
end
