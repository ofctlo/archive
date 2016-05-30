class ChecklistItemsController < ApplicationController
  before_filter :must_be_logged_in
  
  def create
    @item = ChecklistItem.new(params[:checklist_item])
    @item.completed = false
    @item.checklist_id = params[:checklist_id]
    if @item.save
      render json: @item
    else
      render json: { errors: @item.errors.full_messages }, status: 422
    end
  end
  
  def update
    @item = ChecklistItem.find(params[:id])
    if @item.update_attributes(params[:checklist_item])
      render json: @item
    else
      render json: { errors: @item.errors.full_messages }, status: 422
    end
  end
  
  def destroy
    @item = ChecklistItem.find(params[:id])
    @item.destroy
    render json: @item
  end
end
