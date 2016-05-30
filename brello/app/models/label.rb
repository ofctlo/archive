class Label < ActiveRecord::Base
  attr_accessible :title
  
  has_many :card_labels
  has_many :cards, through: :card_labels
end
