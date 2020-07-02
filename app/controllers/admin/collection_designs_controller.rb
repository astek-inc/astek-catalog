module Admin
  class CollectionDesignsController < Admin::BaseController

    before_action :set_design, only: [:update, :edit, :destroy, :custom_materials]
    before_action :set_collection, except: [:edit]
    before_action :set_sale_units, :set_styles, :set_countries, :set_websites, only: [:new, :create, :edit, :update]
    before_action :set_substrates, only: [:custom_materials]
    before_action :set_default_custom_material, only: [:custom_materials]

    def index
      # @designs = Design.where(collection_id: @collection.id).rank(:row_order).page params[:page]
      # @position_start = (@designs.current_page.present? ? @designs.current_page - 1 : 0) * @designs.limit_value
      @designs = Design.where(collection_id: @collection.id).page params[:page]
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

        if params[:default_material_id]
          clear_default_custom_material
          update_default_custom_material
        end

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
    #   render nothing: true
    # end

    def destroy
      @design.destroy
      flash[:notice] = 'Design removed.'
      redirect_to(action: 'index')
    end

    def custom_materials

    end

    private

    def set_design
      @design = Design.find(params[:id])
    end

    def set_collection
      @collection = Collection.find(params[:collection_id])
    end

    def set_sale_units
      @sale_units = SaleUnit.all
    end

    def set_countries
      @countries = Country.all
    end

    def set_styles
      @styles = Style.all
    end

    def set_substrates
      @substrates = Substrate.all
    end

    def set_websites
      @websites = Website.all
    end

    def set_default_custom_material
      @default_custom_material = CustomMaterial.find_by(design_id: @design.id, default_material: true)
    end

    def clear_default_custom_material
      CustomMaterial.where(design_id: @design.id).each do |cm|
        cm.default_material = false
        cm.save!
      end
    end

    def update_default_custom_material
      cm = CustomMaterial.find_by(design_id: @design.id, substrate_id: params[:default_material_id])
      cm.default_material = true
      cm.save!
    end

    def design_params
      params.require(:design).permit(
          :sku, :master_sku, :name, :description, :collection_id, :vendor_id,
          :price_code, :price, :sale_unit_id, :weight, :sale_quantity, :minimum_quantity,
          :available_on, :expires_on, :country_id, :suppress_from_searches, :user_can_select_material,
          :keyword_list, style_ids: [], substrate_ids: [], website_ids: []
      )
    end

  end

end
