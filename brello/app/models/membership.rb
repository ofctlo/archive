class Membership < ActiveRecord::Base
  attr_accessible :user_id, :board_id
  
  validates :user_id, uniqueness: { scope: :board_id }
  
  belongs_to :member, class_name: User,
                      foreign_key: :user_id
  belongs_to :board
end
