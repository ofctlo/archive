require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :fname, :lname, :email, :password, :password_confirmation
  attr_accessor :password, :password_confirmation
  
  # A guest user has no dummy info
  validates :fname, :lname, :email, presence: true, unless: :guest?
  validates :password, presence: true, on: :create, unless: :guest?
  validate :password_matches_confirmation, on: :create, unless: :guest?
  
  has_many :boards
  has_many :memberships
  has_many :member_boards, through: :memberships, source: :board
  
  
  def self.new_guest
    guest_user = User.new
    guest_user.guest = true
    guest_user
  end
  
  
  # Returns both this user's boards and boards shared with this user
  def name
    guest? ? "Guest" : fname
  end
  
  def all_boards
    Board.joins('LEFT OUTER JOIN memberships ON boards.id = memberships.board_id')
         .where('boards.user_id = ? OR memberships.user_id = ?', id, id)
  end
  
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
  
  def password_confirmation=(password_confirmation)
    @password_confirmation = password_confirmation
  end
  
  def verify_password(password)
    return false if self.password_digest == nil
    BCrypt::Password.new(self.password_digest) == password
  end
  
  def generate_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
  end
  
  def to_json(options = {})
    options[:except] ||= [:password_digest, :session_token]
    super(options)
  end
  
  private
  
  def password_matches_confirmation
    errors.add(:password, "Passwords must match") unless
    @password == @password_confirmation
  end
end
