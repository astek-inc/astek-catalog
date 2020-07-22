module Admin
  class DesignImagesController < Admin::BaseController

    before_action :set_image, only: [:show, :destroy]
    before_action :set_design, :set_collection

    def index
    end

    def new
      @design_image = DesignImage.new
    end

    def create
      @design_image = DesignImage.new(design_image_params)
      if @design_image.save!
        flash[:notice] = 'Image added.'
        redirect_to(action: 'index')
      else
        flash[:alert] = 'Error adding image'
        render('new')
      end
    end

    def show
    end

    def destroy
      if @design_image.destroy!
        flash[:notice] = 'Image deleted.'
      else
        flash[:alert] = 'Error deleting image.'
      end
      redirect_to(action: 'index')
    end

    def update_row_order
      @design_image = DesignImage.find(params[:item_id])
      @design_image.row_order_position = params[:row_order_position]
      @design_image.save

      render nothing: true
    end

    private

    def set_image
      @design_image = DesignImage.find(params[:id])
    end

    def set_design
      @design = Design.find(params[:design_id])
    end

    def set_collection
      @collection = @design.collection
    end

    def design_image_params
      params.require(:design_image).permit(:file, :type, :owner_id)
    end

  end
end
