class CardsController < ApplicationController
  before_filter :must_be_logged_in
  
  def create
    @card = Card.new(params[:card])

    list = List.find(params[:list_id])
    @card.position = list.cards.length > 0 ? 
                     list.cards.order(:position).last.position + 1 : 1
    @card.list_id = list.id
    
    if @card.save
      render json: @card
    else
      render json: { errors: @card.errors.full_messages }, status: 422
    end
  end
  
  def update
    @card = Card.find(params[:id])
      
    # an update is either a move...
    if params[:card][:position] != @card.position ||
       params[:card][:list_id] != @card.list_id
      old_list = @card.list
      new_list = List.find(params[:card][:list_id])

      @card.position = -1
      @card.list = new_list
      @card.save

      adjust_positions(old_list.cards)
      insert_at_position(new_list.cards, @card, params[:card][:position])
    # ...or a regular update
    else
      @card.update_attributes(params[:card])
    end

    render json: @card
  end
  
  def destroy
    @card = Card.find(params[:id])
    @card.destroy
    render json: @card
  end
  
  def show
    @card = Card.find(params[:id])
    render json: @card, include: { checklists: { include: :checklist_items },
                                   list: { include: :board } }
  end
  
  private
  
  def adjust_positions(cards)
    # My understanding here is that:
    # 1| a single transaction speeds up the db access
    # 2| keeps some positions from being changed unless all are
    Card.transaction do
      cards.each_with_index do |card, i|
        card.position = i
        card.save
      end
    end
  end
  
  def insert_at_position(cards, card, position)
    cards.where('position >= ?', position).update_all('position = position + 1')
    card.position = position
    card.save
  end
end