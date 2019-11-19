module Admin
  class DesignDescriptionsController < BaseController

    before_action :set_description, only: [:edit, :update, :destroy]
    before_action :set_design
    before_action :set_collection
    before_action :set_websites #, only: [:new, :edit]

    def index
      @descriptions = Description.where(descriptionable_id: @design.id, descriptionable_type: 'Design')
    end

    def new
      @description = Description.new
    end

    def create
      @description = Description.new(description_params)
      require 'pp'
      pp @description
      puts '- '*30
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

    def update_row_order
      @description = Description.find(params[:item_id])
      @description.row_order_position = params[:row_order_position]
      @description.save

      render nothing: true
    end

    private

    def set_description
      @description = Description.find(params[:id])
    end

    def set_design
      @design = Design.find(params[:design_id])
    end

    def set_collection
      @collection = @design.collection
    end

    def set_websites
      @websites = Website.all
    end

    def description_params
      params.require(:description).permit(:descriptionable_type, :descriptionable_id, :description, website_ids: [])
    end

  end

end
