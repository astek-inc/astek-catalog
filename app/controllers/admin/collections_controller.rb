module Admin
  class CollectionsController < Admin::BaseController

    before_action :set_product_categories, :set_websites, :set_lead_times, only: [:new, :edit]

    def index
      @collections = Collection.all.page params[:page]
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
        if @collection.errors.any?
          msg = @collection.errors.full_messages.join(', ')
        else
          msg = 'Error creating collection.'
        end
        flash[:error] = msg
        render('new')
      end
    end

    def edit
      @collection = Collection.find(params[:id])
    end

    def update
      @collection = Collection.find(params[:id])
      if @collection.update_attributes(collection_params)
        flash[:notice] = 'Collection updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def delete
      @collection = Collection.find(params[:id])
    end

    def update_row_order
      @collection = Collection.find(params[:item_id])
      @collection.row_order_position = params[:row_order_position]
      @collection.save

      render nothing: true
    end

    def destroy
      Collection.find(params[:id]).destroy
      flash[:notice] = 'Collection destroyed.'
      redirect_to(action: 'index')
    end

    def search
      @collections = Collection.joins(:websites).where('collections.name LIKE ?', params[:term] + '%').where('websites.id = ?', params[:website_id])
      render json: @collections, each_serializer: CollectionSearchResultSerializer, root: nil, adapter: :attributes
      # render json: @collections.map { |c| { id: c.id, value: c.name } }.to_json
    end

    private

    def set_product_categories
      @product_categories = ProductCategory.rank(:row_order)
    end

    def set_websites
      @websites = Website.all
    end

    def set_lead_times
      @lead_times = LeadTime.rank(:row_order)
    end

    def collection_params
      params.require(:collection).permit(:name, :description, :keywords, :product_category_id, :lead_time_id, :vendor_id, :user_can_select_material, :suppress_from_display, website_ids: [])
    end

  end

end
