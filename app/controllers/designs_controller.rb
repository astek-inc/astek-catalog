class DesignsController < BaseController

  def index
    @designs = Design.rank(:row_order).page params[:page]
  end

  def show
    @design = Design.find(params[:id])
  end

end
