class CollectionsController < ApplicationController
  def index
    @collections = Collection.page params[:page]
  end

  def show
    @collection = Collection.find(params[:id])
  end
end
