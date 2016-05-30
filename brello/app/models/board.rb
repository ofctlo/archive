class Board < ActiveRecord::Base
  attr_accessible :title, :user_id
  
  validates :title, presence: true
  
  belongs_to :user
  has_many :lists, dependent: :destroy
  has_many :memberships
  has_many :members, through: :memberships
  
  default_scope order('id ASC')
end
