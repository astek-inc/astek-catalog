module Admin
  class SubcollectionTypesController < Admin::BaseController

    before_action :set_subcollection_type, only: [:edit, :update, :destroy]

    def index
      @subcollection_types = SubcollectionType.all
    end

    def new
      @subcollection_type = SubcollectionType.new
    end

    def create
      @subcollection_type = SubcollectionType.new(subcollection_type_params)
      if @subcollection_type.save
        flash[:notice] = 'Subcollection type created.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @subcollection_type
        render('new')
      end
    end

    def edit
    end

    def update
      if @subcollection_type.update_attributes(subcollection_type_params)
        flash[:notice] = 'Subcollection type updated.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @subcollection_type
        render('edit')
      end
    end

    def destroy
      @subcollection_type.destroy
      flash[:notice] = 'Subcollection type removed.'
      redirect_to(action: 'index')
    end

    private

    def set_subcollection_type
      @subcollection_type = SubcollectionType.find(params[:id])
    end

    def subcollection_type_params
      params.require(:subcollection_type).permit(:name)
    end

  end
end
