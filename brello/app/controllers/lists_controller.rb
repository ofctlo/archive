class ListsController < ApplicationController
  before_filter :must_be_logged_in
  
  def create
    @list = List.new(params[:list])
    
    board = Board.find(params[:board_id])
    @list.position = board.lists.length > 0 ?
                     board.lists.order(:position).last.position + 1 : 1
    @list.board_id = params[:board_id]
    
    if @list.save
      render json: @list
    else
      render json: { errors: @list.errors.full_messages }, status: 422
    end
  end
  
  def update
    @list = List.find(params[:id])
    if @list.update_attributes(params[:list])
      render json: @list
    else
      render json: { errors: @list.errors.full_messages }, status: 422
    end
  end
  
  def destroy
    @list = List.find(params[:id])
    @list.destroy
    render json: @list
  end
end
