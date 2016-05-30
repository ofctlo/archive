class Checklist < ActiveRecord::Base
  attr_accessible :title
  
  validates :title, :card_id, presence: true
  
  belongs_to :card
  has_many :checklist_items, dependent: :destroy
end
