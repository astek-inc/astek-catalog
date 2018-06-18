module Admin
  class UsersController < BaseController

    def index
      @users = User.all
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save

        if params[:user][:is_admin] == '1'
          @user.add_role :admin
        else
          @user.remove_role :admin
        end

        flash[:notice] = 'User created.'
        redirect_to(action: 'index')
      else

        flash[:error] = @user.errors.full_messages.uniq.join('. ')
        render('new')
      end
    end

    def edit
      @user = User.find(params[:id])
    end

    def update

      @user = User.find(params[:id])

      if @user.update_attributes(user_params)
        if params[:user][:is_admin] == '1'
          @user.add_role :admin
        else
          @user.remove_role :admin
        end

        flash[:notice] = 'User updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end

    end

    def delete
      @user = User.find(params[:id])
    end

    def destroy
      User.find(params[:id]).destroy
      flash[:notice] = 'User removed.'
      redirect_to(action: 'index')
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :is_admin)
    end

  end
end
