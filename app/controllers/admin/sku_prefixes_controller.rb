module Admin
  class SkuPrefixesController < Admin::BaseController

    before_action :set_sku_prefix, only: [:edit, :update, :destroy]

    def index
      @sku_prefixes = SkuPrefix.all
    end

    def new
      @sku_prefix = SkuPrefix.new
    end

    def create
      @sku_prefix = SkuPrefix.new(sku_prefix_params)
      if @sku_prefix.save
        flash[:notice] = 'SKU prefix created.'
        redirect_to(action: 'index')
      else
        if @sku_prefix.errors.any?
          msg = @sku_prefix.errors.full_messages.join(', ')
        else
          msg = 'Error creating SKU prefix.'
        end
        flash[:error] = msg
        render('new')
      end
    end

    def edit
    end

    def update
      if @sku_prefix.update(sku_prefix_params)
        flash[:notice] = 'SKU prefix updated.'
        redirect_to(action: 'index')
      else
        if @sku_prefix.errors.any?
          msg = @sku_prefix.errors.full_messages.join(', ')
        else
          msg = 'Error updating SKU prefix.'
        end
        flash[:error] = msg
        render('edit')
      end
    end

    def destroy
      @sku_prefix.destroy
      flash[:notice] = 'SKU prefix removed.'
      redirect_to(action: 'index')
    end

    private

    def set_sku_prefix
      @sku_prefix = SkuPrefix.find(params[:id])
    end

    def sku_prefix_params
      params.require(:sku_prefix).permit(:prefix, :separator, :description)
    end
  end
end
