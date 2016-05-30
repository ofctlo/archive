class MembershipsController < ApplicationController
  def create
    board = Board.find(params[:board_id])
    
    user_info = params[:user]
    user = user_info.split.length > 1 ? 
        User.find_by_fname_and_lname(*user_info.split) : 
        User.find_by_email(user_info)
    
    if user
      membership = board.memberships.build(user_id: user.id)
      membership.save
      render json: membership, include: { member: { except: [:password_digest, :session_token] } }
    else
      render json: { errors: "Invalid user name or email" }, status: 422
    end
  end
  
  def destroy
    @membership = Membership.find(params[:id])
    @membership.destroy
    render json: @membership
  end
end
