class UsersController < ApplicationController
  before_filter :must_be_logged_in, except: [:new, :create]
  
  def new
    @user = User.new
  end
  
  def create
    @user = params[:user] ? User.new(params[:user]) : User.new_guest
    if @user.save
      sign_in!(@user)
      redirect_to root_url
    else
      render :new
    end
  end
  
  # board collaborators
  def index
    @board = Board.find(params[:board_id])
    render json: @board.members
  end
  
  def show
    @user = User.find(params[:id])
    render json: @user
  end
end
