module Admin
  class CollectionDesignsController < Admin::BaseController

    before_action :set_design, only: [:update, :edit, :destroy, :custom_materials]
    before_action :set_collection, except: [:edit]
    before_action :set_styles, :set_countries, :set_websites, only: [:new, :create, :edit, :update]

    def index
      # @designs = Design.where(collection_id: @collection.id).rank(:row_order).page params[:page]
      # @position_start = (@designs.current_page.present? ? @designs.current_page - 1 : 0) * @designs.limit_value
      @designs = Design.where(collection_id: @collection.id).page(params[:page]).includes(:websites)
    end

    def new
      @design = Design.new
      @design.websites = @collection.websites
    end

    def create
      @design = Design.new(design_params)
      if @design.save
        flash[:notice] = 'Design created.'
        redirect_to(action: 'edit', id: @design.id)
      else
        flash[:error] = error_message @design
        render('new')
      end
    end

    def edit
      @collection = @design.collection
    end

    def update
      if @design.update_attributes(design_params)
        flash[:notice] = 'Design updated.'
        redirect_to(action: 'edit', id: @design.id)
      else
        flash[:error] = error_message @design
        render('edit')
      end
    end

    # def delete
    #   @design = Design.find(params[:id])
    # end

    # def update_row_order
    #   @design = Design.find(params[:item_id])
    #   @design.row_order_position = params[:row_order_position]
    #   @design.save
    #
    #   head :ok
    # end

    def destroy
      @design.destroy
      flash[:notice] = 'Design removed.'
      redirect_to(action: 'index')
    end

    private

    def set_design
      @design = Design.find(params[:id])
    end

    def set_collection
      @collection = Collection.find(params[:collection_id])
    end

    def set_countries
      @countries = Country.all
    end

    def set_styles
      @styles = Style.all
    end

    def set_websites
      @websites = Website.all
    end

    def design_params
      params.require(:design).permit(
          :sku, :master_sku, :name, :description, :collection_id, :vendor_id,
          :available_on, :expires_on, :country_id, :suppress_from_searches,
          :keyword_list, style_ids: [], website_ids: []
      )
    end

  end

end
