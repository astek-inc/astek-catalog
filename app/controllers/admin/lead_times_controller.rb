module Admin
  class LeadTimesController < Admin::BaseController

    before_action :set_lead_time, only: [:edit, :update, :destroy]

    def index
      @lead_times = LeadTime.page params[:page]
    end

    def new
      @lead_time = LeadTime.new
    end

    def create
      @lead_time = LeadTime.new(lead_time_params)
      if @lead_time.save
        flash[:notice] = 'Lead time created.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @lead_time
        render('new')
      end
    end

    def edit
    end

    def update
      if @lead_time.update(lead_time_params)
        flash[:notice] = 'Lead time updated.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @lead_time
        render('edit')
      end
    end

    def destroy
      @lead_time.destroy
    end

    private

    def set_lead_time
      @lead_time = LeadTime.find(params[:id])
    end

    def lead_time_params
      params.require(:lead_time).permit(:name, :description)
    end

  end
end
