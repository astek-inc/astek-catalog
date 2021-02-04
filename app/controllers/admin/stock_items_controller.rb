module Admin
  class StockItemsController < Admin::BaseController

    before_action :set_stock_item, except: [:index, :new, :create, :update_row_order]
    before_action :set_variant, :set_design, :set_collection, :set_substrates, :set_backing_types, :set_sale_units,
                  :set_websites, except: [:destroy]

    def index
      @stock_items = StockItem.where(variant_id: params[:variant_id]).rank(:row_order)
    end

    def new
      @stock_item = StockItem.new
      @stock_item.websites = @variant.websites
    end

    def create
      @stock_item = StockItem.new(stock_item_params)
      if @stock_item.save
        flash[:notice] = 'Stock item added.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @stock_item
        render('new')
      end
    end

    def edit

    end

    def update
      if @stock_item.update(stock_item_params)
        flash[:notice] = 'Stock item updated.'
        redirect_to(action: 'edit')
      else
        flash[:error] = error_message @stock_item
        render('edit')
      end
    end

    def destroy
      @stock_item.destroy
      flash[:notice] = 'Stock item removed.'
      redirect_to(action: 'index')
    end

    def update_row_order
      @stock_item = StockItem.find(params[:item_id])
      @stock_item.row_order_position = params[:row_order_position]
      @stock_item.save
      head :ok
    end

    private

    def set_stock_item
      @stock_item = StockItem.find(params[:id])
    end

    def set_variant
      @variant = Variant.find(params[:variant_id])
    end

    def set_substrates
      @substrates = Substrate.all
    end

    def set_backing_types
      @backing_types = BackingType.all
    end

    def set_design
      @design = @variant.design
    end

    def set_collection
      @collection = @design.collection
    end

    def set_sale_units
      @sale_units = SaleUnit.all
    end

    def set_websites
      @websites = Website.all
    end

    def stock_item_params
      params.require(:stock_item).permit(
        :variant_id, :substrate_id, :backing_type_id,
        :price_code, :price, :sale_price, :display_sale_price, :sale_unit_id, :sale_quantity, :minimum_quantity,
        :weight, :width, :height, :depth,
        website_ids: []
      )
    end

  end
end
