module Admin
  class SaleUnitsController < Admin::BaseController

    before_action :set_sale_unit, only: [:edit, :update, :destroy]

    def index
      @sale_units = SaleUnit.page params[:page]
    end

    def new
      @sale_unit = SaleUnit.new
    end

    def create
      @sale_unit = SaleUnit.new(sale_unit_params)
      if @sale_unit.save
        flash[:notice] = 'Sale unit created.'
        redirect_to(action: 'index')
      else
        if @sale_unit.errors.any?
          msg = @sale_unit.errors.full_messages.join(', ')
        else
          msg = 'Error creating sale unit.'
        end
        flash[:error] = msg
        render('new')
      end
    end

    def edit
    end

    def update
      if @sale_unit.update(sale_unit_params)
        flash[:notice] = 'Sale unit updated.'
        redirect_to(action: 'index')
      else
        if @sale_unit.errors.any?
          msg = @sale_unit.errors.full_messages.join(', ')
        else
          msg = 'Error updating sale unit.'
        end
        flash[:error] = msg
        render('edit')
      end
    end

    def destroy
      @sale_unit.destroy
      flash[:notice] = 'Sale unit removed.'
      redirect_to(action: 'index')
    end

    private

    def set_sale_unit
      @sale_unit = SaleUnit.find(params[:id])
    end

    def sale_unit_params
      params.require(:sale_unit).permit(:name, :description)
    end

  end
end
