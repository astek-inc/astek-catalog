module Api
  module V1
    class CollectionsController < ::ApplicationController

      def index
        @collections = Collection.rank(:row_order).all
        render json: @collections
      end

      def create
        @collection = Collection.new(collection_params)
        @collection.save!
        render json: @collection
      end

      def show
        @collection = Collection.friendly.find(params[:id])
        render json: @collection
      end

      def update
        @collection = Collection.friendly.find(params[:id])
        if @collection.update_attributes(collection_params)
          render json: @collection
        else
          raise 'Error trying to update collection'
        end
      end

      def destroy
        Collection.friendly.find(params[:id]).destroy
      end

      private

      def collection_params
        params.require(:collection).permit(:category_id, :name, :description, :keywords, :slug)
      end

    end
  end
end
