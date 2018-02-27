module Admin
  class CollectionImagesController < Admin::BaseController

    before_action :get_collection

    def index
    end

    def new
      @collection_image = CollectionImage.new
    end

    def create
      @collection_image = CollectionImage.new(collection_image_params)
      if @collection_image.save!
        flash[:notice] = 'Image added.'
        redirect_to(action: 'index')
      else
        flash[:alert] = 'Error adding image'
        render('new')
      end
    end

    def show
      @collection_image = CollectionImage.find(params[:id])
    end

    def destroy
      @collection_image = Image.find(params[:id])
      if @collection_image.destroy!
        flash[:notice] = 'Image deleted.'
      else
        flash[:alert] = 'Error deleting image.'
      end
      redirect_to(action: 'index')
    end

    def update_row_order
      @collection_image = CollectionImage.find(params[:item_id])
      @collection_image.row_order_position = params[:row_order_position]
      @collection_image.save

      render nothing: true
    end

    private

    def get_collection
      @collection = Collection.friendly.find(params[:collection_id])
    end

    def collection_image_params
      params.require(:collection_image).permit(:file, :type, :owner_id)
    end

  end
end
