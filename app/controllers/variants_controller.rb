class VariantsController < BaseController

  def index
    @variants = Variant.rank(:row_order)
  end

  def show
    @variant = Variant.find(params[:id])
  end

end
