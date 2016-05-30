namespace :positions do
  desc "Reset positions if they get out of sync due to testing"
  task reset: :environment do
    Board.all.each do |board|
      list_pos = 0
      board.lists.each do |list|
        card_pos = 0
        list.cards.each do |card|
          card.position = card_pos
          card.save
          card_pos += 1
        end
    
        list.position = list_pos
        list.save
        list_pos += 1
      end
    end
  end
end