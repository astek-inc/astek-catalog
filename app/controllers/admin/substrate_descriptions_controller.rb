module Admin
  class SubstrateDescriptionsController < BaseController

    before_action :set_description, only: [:edit, :update, :destroy]
    before_action :set_substrate
    before_action :set_websites, except: [:index, :update_row_order]

    def index
      @descriptions = Description.where(descriptionable_id: @substrate.id, descriptionable_type: 'Substrate')
    end

    def new
      @description = Description.new
    end

    def create
      @description = Description.new(description_params)
      if @description.save
        flash[:notice] = 'Description created.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @description
        render('new')
      end
    end

    def edit
    end

    def update
      if @description.update(description_params)
        flash[:notice] = 'Description updated.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @description
        render('edit')
      end
    end

    def destroy
      @description.destroy
      flash[:notice] = 'Description removed.'
      redirect_to(action: 'index')
    end

    private

    def set_description
      @description = Description.find(params[:id])
    end

    def set_substrate
      @substrate = Substrate.find(params[:substrate_id])
    end

    def set_websites
      @websites = Website.all
    end

    def description_params
      params.require(:description).permit(:descriptionable_type, :descriptionable_id, :description, website_ids: [])
    end

  end
end
