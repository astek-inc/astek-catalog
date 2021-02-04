module Admin
  class VariantsController < Admin::BaseController

    before_action :set_variant, only: [:edit, :update, :destroy]
    before_action :set_design, :set_collection
    before_action :set_sale_units, :set_product_types, :set_colors, :set_substrates, :set_backing_types, only: [:new, :create, :edit, :update]
    before_action :set_websites, only: [:new, :edit]

    def index
      @variants = Variant.where(design_id: @design.id).rank(:row_order).page(params[:page]).includes(:variant_type, :websites)
      @position_start = (@variants.current_page.present? ? @variants.current_page - 1 : 0) * @variants.limit_value
    end

    def new
      @variant = Variant.new
      @variant.websites = @design.websites
    end

    def create
      @variant = Variant.new(variant_params)
      if @variant.save
        flash[:notice] = 'Variant created.'
        redirect_to(action: 'edit', id: @variant.id)
      else
        flash[:error] = error_message @variant
        render('new')
      end
    end

    def edit
    end

    def update
      if @variant.update_attributes(variant_params)
        flash[:notice] = 'Variant updated.'
        redirect_to(action: 'edit', id: @variant.id)
      else
        flash[:error] = error_message @variant
        render('edit')
      end
    end

    def update_row_order
      @variant = Variant.find(params[:item_id])
      @variant.row_order_position = params[:row_order_position]
      @variant.save

      head :ok
    end

    def destroy
      @variant.destroy
      flash[:notice] = 'Variant removed.'
      redirect_to(action: 'index')
    end

    private

    def set_variant
      @variant = Variant.find(params[:id])
    end

    def set_design
      @design = Design.find(params[:design_id])
    end

    def set_collection
      @collection = @design.collection
    end

    def set_sale_units
      @sale_units = SaleUnit.all
    end

    def set_product_types
      @product_types = ProductType.all
    end

    def set_colors
      @colors = Color.all
    end

    def set_substrates
      @substrates = Substrate.all
    end

    def set_backing_types
      @backing_types = BackingType.rank(:row_order)
    end

    def set_websites
      @websites = Website.all
    end

    def variant_params
      params.require(:variant).permit(
          :variant_type_id, :name, :sku, :keywords, :design_id,
          product_type_ids: [], color_ids: [], website_ids: []
      )
    end

  end
end
