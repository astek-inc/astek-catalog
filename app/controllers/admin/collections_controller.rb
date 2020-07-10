module Admin
  class CollectionsController < Admin::BaseController

    before_action :set_collection, only: [:edit, :update, :destroy]
    before_action :set_product_categories, :set_websites, :set_lead_times, only: [:new, :create, :edit, :update]

    def index
      @collections = Collection.page(params[:page]).includes(:product_category, :websites)
    end

    def new
      @collection = Collection.new
    end

    def create
      @collection = Collection.new(collection_params)
      if @collection.save
        flash[:notice] = 'Collection created.'
        redirect_to(action: 'edit', id: @collection.id)
      else
        flash[:error] = error_message @collection
        render('new')
      end
    end

    def edit
    end

    def update
      if @collection.update_attributes(collection_params)
        flash[:notice] = 'Collection updated.'
        redirect_to(action: 'edit', id: @collection.id)
      else
        flash[:error] = error_message @collection
        render('edit')
      end
    end

    def destroy
      @collection.destroy
      flash[:notice] = 'Collection removed.'
      redirect_to(action: 'index')
    end

    def csv_export_search
      domain = Website.find(params[:website_id]).domain
      @collections = Collection.where('collections.name LIKE ?', params[:term] + '%').for_domain(domain)
      render json: @collections, each_serializer: CollectionSearchResultSerializer, root: nil, adapter: :attributes
    end

    private

    def set_collection
      @collection = Collection.find(params[:id])
    end

    def set_product_categories
      @product_categories = ProductCategory.all
    end

    def set_websites
      @websites = Website.all
    end

    def set_lead_times
      @lead_times = LeadTime.all
    end

    def collection_params
      params.require(:collection).permit(
          :name, :description, :keywords, :product_category_id, :lead_time_id,
          :suppress_from_display, :suppress_sample_option_from_display, :prepend_collection_name_to_design_names,
          :keyword_list,
          website_ids: []
      )
    end

  end

end
