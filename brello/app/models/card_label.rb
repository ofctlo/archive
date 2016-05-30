class CardLabel < ActiveRecord::Base
  attr_accessible :card_id, :label_id
  
  belongs_to :card
  belongs_to :label
end
