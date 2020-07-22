module Admin
  class KeywordsController < Admin::BaseController

    before_action :set_keyword, only: [:edit, :update, :destroy]

    def index
      @keywords = Keyword.page params[:page]
    end

    def list
      @keywords = Keyword.all
      respond_to do |format|
        format.json do
          render json: @keywords, each_serializer: KeywordSerializer, root: nil, adapter: :attributes
        end
      end
    end

    def new
      @keyword = Keyword.new
    end

    def edit
    end

    def create
      @keyword = Keyword.new(keyword_params)
      if @keyword.save
        flash[:notice] = 'Keyword created.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @keyword
        render('new')
      end
    end

    def update
      if @keyword.update(keyword_params)
        flash[:notice] = 'Keyword updated.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @substrate
        render('edit')
      end
    end

    def destroy
      @keyword.destroy
      flash[:notice] = 'Keyword removed.'
      redirect_to(action: 'index')
    end

    private

      def set_keyword
        @keyword = Keyword.find(params[:id])
      end

      def keyword_params
        params.require(:keyword).permit(:name)
      end

  end
end
