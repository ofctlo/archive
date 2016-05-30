class SessionsController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.find_by_email(params[:user][:email])
    if @user && @user.verify_password(params[:user][:password])
      sign_in!(@user)
      redirect_to root_url
    else
      render :new
    end
  end
  
  def destroy
    sign_out!(current_user)
    redirect_to new_session_url
  end
end
