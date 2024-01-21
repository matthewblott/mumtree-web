class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @app_session = @user.app_sessions.create
      log_in(@app_session)

      @organization = Organization.create(members: [@user])
      redirect_to(
        root_path,
        status: :see_other,
        flash: {success: t(".welcome", name: @user.name)}
      )
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
