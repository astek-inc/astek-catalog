module Admin
  class SubstrateCategoriesController < Admin::BaseController

    def index
      @substrate_categories = SubstrateCategory.all
    end

    def new
      @substrate_category = SubstrateCategory.new
    end

    def create
      @substrate_category = SubstrateCategory.new(substrate_category_params)
      if @substrate_category.save
        flash[:notice] = 'Substrate category created.'
        redirect_to(action: 'index')
      else
        if @substrate_category.errors.any?
          msg = @substrate_category.errors.full_messages.join(', ')
        else
          msg = 'Error creating substrate category.'
        end
        flash[:error] = msg
        render('new')
      end
    end

    def edit
      @substrate_category = SubstrateCategory.find(params[:id])
    end

    def update
      @substrate_category = SubstrateCategory.find(params[:id])
      if @substrate_category.update_attributes(substrate_category_params)
        flash[:notice] = 'Substrate category updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def destroy
      SubstrateCategory.find(params[:id]).destroy
      flash[:notice] = 'Substrate category destroyed.'
      redirect_to(action: 'index')
    end

    private

    def substrate_category_params
      params.require(:substrate_category).permit(:name)
    end

  end
end
