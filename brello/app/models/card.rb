class Card < ActiveRecord::Base
  attr_accessible :title, :description, :list_id, :position, :due_date
  
  validates :title, :list_id, :position, presence: true

  belongs_to :list
  has_many :checklists, dependent: :destroy
  has_many :card_labels, dependent: :destroy
  has_many :labels, through: :card_labels
  
  default_scope order('position ASC')
end
