module Admin
  class VariantsController < Admin::BaseController

    before_action :set_variant, only: [:edit, :update, :destroy]
    before_action :set_design, :set_collection
    before_action :set_colors, :set_substrates, :set_backing_types, only: [:new, :edit]

    def index
      @variants = Variant.where(design_id: @design.id).rank(:row_order).page params[:page]
      @position_start = (@variants.current_page.present? ? @variants.current_page - 1 : 0) * @variants.limit_value
    end

    def new
      @variant = Variant.new
    end

    def create
      @variant = Variant.new(variant_params)
      if @variant.save
        flash[:notice] = 'Variant created.'
        redirect_to(action: 'index')
      else
        if @variant.errors.any?
          msg = @variant.errors.full_messages.join(', ')
        else
          msg = 'Error creating variant.'
        end
        flash[:error] = msg
        render('new')
      end
    end

    def edit
    end

    def update
      if @variant.update_attributes(variant_params)
        flash[:notice] = 'Variant updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def update_row_order
      @variant = Variant.find(params[:item_id])
      @variant.row_order_position = params[:row_order_position]
      @variant.save

      render nothing: true
    end

    def destroy
      @variant.destroy
      flash[:notice] = 'Variant destroyed.'
      redirect_to(action: 'index')
    end

    private

    def set_variant
      @variant = Variant.friendly.find(params[:id])
    end

    def set_design
      @design = Design.friendly.find(params[:design_id])
    end

    def set_collection
      @collection = @design.collection
    end

    def set_colors
      @colors = Color.rank(:row_order)
    end

    def set_substrates
      @substrates = Substrate.rank(:row_order)
    end

    def set_backing_types
      @backing_types = BackingType.rank(:row_order)
    end

    def variant_params
      params.require(:variant).permit(:variant_type_id, :name, :sku, :keywords, :slug, :design_id, :substrate_id, :backing_type_id, color_ids: [])
    end

  end
end
