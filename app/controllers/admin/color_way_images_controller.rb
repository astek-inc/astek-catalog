module Admin
  class ColorWayImagesController < Admin::BaseController

    before_action :get_color_way, :get_design, :get_collection

    def index
    end

    def new
      @color_way_image = ColorWayImage.new
    end

    def create
      @color_way_image = ColorWayImage.new(design_image_params)
      if @color_way_image.save!
        flash[:notice] = 'Image added.'
        redirect_to(action: 'index')
      else
        flash[:alert] = 'Error adding image'
        render('new')
      end
    end

    def destroy
      @color_way_image = ColorWayImage.find(params[:id])
      if @color_way_image.destroy!
        flash[:notice] = 'Image deleted.'
      else
        flash[:alert] = 'Error deleting image.'
      end
      redirect_to(action: 'index')
    end

    def update_row_order
      @color_way_image = ColorWayImage.find(params[:item_id])
      @color_way_image.row_order_position = params[:row_order_position]
      @color_way_image.save

      render nothing: true
    end

    private

    def get_color_way
      @color_way = ColorWay.friendly.find(params[:color_way_id])
    end

    def get_design
      @design = @color_way.design
    end

    def get_collection
      @collection = @design.collection
    end

    def color_way_image_params
      params.require(:color_way_image).permit(:file, :type, :owner_id)
    end

  end
end
