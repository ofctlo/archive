class ChecklistsController < ApplicationController
  before_filter :must_be_logged_in
  
  def create
    @checklist = Checklist.new(params[:checklist])
    @checklist.card_id = params[:card_id]
    if @checklist.save
      render json: @checklist
    else
      render json: { errors: @checklist.errors.full_messages }, status: 422
    end
  end
  
  def update
    @checklist = Checklist.find(params[:id])
    if @checklist.update_attributes(params[:checklist])
      render json: @checklist
    else
      render json: { errors: @checklist.errors.full_messages }, status: 422
    end
  end
  
  def destroy
    @checklist = Checklist.find(params[:id])
    @checklist.destroy
    render json: @checklist
  end
end
