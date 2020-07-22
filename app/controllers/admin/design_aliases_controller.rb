module Admin
  class DesignAliasesController < BaseController

    before_action :set_design_alias, only: [:edit, :update, :destroy]
    before_action :set_collection
    before_action :set_websites, only: [:new, :edit]

    def index
      @design_aliases = DesignAlias.where(collection_id: @collection.id)
    end

    def new
      @design_alias = DesignAlias.new
      @design_alias.collection = @collection
      @design_alias.websites = @collection.websites
    end

    def edit
    end

    def create
      @design_alias = DesignAlias.new(design_alias_params)

      if @design_alias.save
        flash[:notice] = 'Design alias created.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @design_alias
        render('new')
      end
    end

    def update
      if @design_alias.update(design_alias_params)
        flash[:notice] = 'Design alias updated.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @design_alias
        render('edit')
      end
    end

    def destroy
      @design_alias.destroy
      flash[:notice] = 'Design alias removed.'
      redirect_to(action: 'index')
    end

    private

    def set_design_alias
      @design_alias = DesignAlias.find(params[:id])
    end

    def set_collection
      @collection = Collection.find(params[:collection_id])
    end

    def set_websites
      @websites = Website.all
    end

    def design_alias_params
      params.require(:design_alias).permit(:collection_id, :design_id, :description, website_ids: [])
    end

  end
end
