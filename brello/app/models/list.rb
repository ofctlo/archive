class List < ActiveRecord::Base
  attr_accessible :title, :board_id, :position
  
  validates :title, :board_id, presence: true
  
  belongs_to :board
  has_many :cards, dependent: :destroy

  default_scope order('position ASC')
  
  def as_json(options = {})
    super(options.merge(include: :cards))
  end
end
