module Admin
  class DesignStylesController < Admin::BaseController

    before_action :get_design, :get_collection, :get_styles

    def index

    end

    private

    def get_design
      @design = Design.friendly.find(params[:design_id])
    end

    def get_collection
      @collection = @design.collection
    end

    def get_styles
      @styles = Style.all
    end

  end
end
