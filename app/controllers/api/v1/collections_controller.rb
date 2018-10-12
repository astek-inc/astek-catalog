module Api
  module V1
    class CollectionsController < BaseController

      def index
        @collections = Collection.all.all
        render json: @collections
      end

      # def create
      #   @collection = Collection.new(collection_params)
      #   @collection.save!
      #   render json: @collection
      # end

      def show
        @collection = Collection.find(params[:id])
        render json: @collection
      end

      # def update
      #   @collection = Collection.find(params[:id])
      #   if @collection.update_attributes(collection_params)
      #     render json: @collection
      #   else
      #     raise 'Error trying to update collection'
      #   end
      # end
      #
      # def destroy
      #   Collection.find(params[:id]).destroy
      # end
      #
      # private
      #
      # def collection_params
      #   params.require(:collection).permit(:product_type_id, :name, :description, :keywords)
      # end

    end
  end
end
