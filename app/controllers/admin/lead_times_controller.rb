module Admin
  class LeadTimesController < Admin::BaseController

    before_action :set_lead_time, only: [:edit, :update, :destroy]

    def index
      @lead_times = LeadTime.page params[:page]
      @position_start = (@lead_times.current_page.present? ? @lead_times.current_page - 1 : 0) * @lead_times.limit_value
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
        if @lead_time.errors.any?
          msg = @lead_time.errors.full_messages.join(', ')
        else
          msg = 'Error creating lead time.'
        end
        flash[:error] = msg
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
        if @lead_time.errors.any?
          msg = @lead_time.errors.full_messages.join(', ')
        else
          msg = 'Error creating lead time.'
        end
        flash[:error] = msg
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
