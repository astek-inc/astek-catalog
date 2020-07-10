module Admin
  class SubcollectionsController < Admin::BaseController

    before_action :set_subcollection_types, only: [:new, :edit]
    before_action :set_subcollection, only: [:edit, :update, :destroy]
    before_action :set_collection

    def index
      @subcollections = Subcollection.where(collection_id: params[:collection_id]).includes(:subcollection_type)
    end

    def new
      @subcollection = Subcollection.new
    end

    def create
      @subcollection = Subcollection.new(subcollection_params)
      if @subcollection.save
        flash[:notice] = 'Subcollection created.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @subcollection
        render('new')
      end
    end

    def edit
    end

    def update
      if @subcollection.update_attributes(subcollection_params)
        flash[:notice] = 'Subcollection updated.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @subcollection
        render('edit')
      end
    end

    def destroy
      @subcollection.destroy
      flash[:notice] = 'Subcollection removed.'
      redirect_to(action: 'index')
    end

    private

    def set_subcollection
      @subcollection = Subcollection.find(params[:id])
    end

    def set_collection
      @collection = Collection.find(params[:collection_id])
    end

    def set_subcollection_types
      @subcollection_types = SubcollectionType.all
    end

    def subcollection_params
      params.require(:subcollection).permit(:name, :subcollection_type_id, :collection_id, design_ids: [])
    end

  end
end
