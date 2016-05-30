class BoardsController < ApplicationController
  before_filter :must_be_logged_in
  
  def create
    @board = Board.new(params[:board])
    @board.user_id = current_user.id
    
    if @board.save
      render json: @board
    else
      render json: { errors: @board.errors.full_messages }, status: 422
    end
  end
  
  def index
    # all_boards returns the user's boards plus collaborating boards
    @boards = current_user.all_boards
    render json: @boards, only: [:id, :title, :user_id]
  end
  
  def show
    @board = Board.find(params[:id])
    render json: @board, include: { 
      lists: { include: :cards },
      memberships: { include: { 
        member: { except: [:password_digest, :session_token] } } },
      user: { }
    }
  end
  
  def update
    @board = Board.find(params[:id])
    if @board.update_attributes(params[:board])
      render json: @board
    else
      render json: { errors: @board.errors.full_messages }, status: 422
    end
  end
end
