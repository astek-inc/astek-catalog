module Admin
  class CollectionsController < Admin::BaseController

    def index
      @collections = Collection.rank(:row_order).page params[:page]
      @position_start = (@collections.current_page.present? ? @collections.current_page - 1 : 0) * @collections.limit_value
    end

    def new
      @collection = Collection.new
    end

    def create
      @collection = Collection.new(collection_params)
      if @collection.save
        flash[:notice] = 'Collection created.'
        redirect_to(action: 'index')
      else
        render('new')
      end
    end

    def edit
      @collection = Collection.friendly.find(params[:id])
    end

    def update
      @collection = Collection.friendly.find(params[:id])
      if @collection.update_attributes(collection_params)
        flash[:notice] = 'Collection updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def delete
      @collection = Collection.friendly.find(params[:id])
    end

    def update_row_order
      @collection = Collection.find(params[:item_id])
      @collection.row_order_position = params[:row_order_position]
      @collection.save

      render nothing: true
    end

    def destroy
      Collection.friendly.find(params[:id]).destroy
      flash[:notice] = "Collection destroyed."
      redirect_to(action: 'index')
    end

    private

    def collection_params
      params.require(:collection).permit(:name, :description, :keywords, :slug, :category_id, :image, :image_cache)
    end

  end

end
