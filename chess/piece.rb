require 'colored'

class Piece
  attr_reader :moved
  attr_accessor :color, :location
  alias_method :moved?, :moved

  def initialize(board, location, color)
    @board = board
    @location = location
    unless [:red, :blue].include?(color)
      raise ArgumentError.new "Invalid Color. Must be :blue or :red."
    end
    @color = color
    @moved = false
  end

  def dup(board)
    self.class.new(board, @location, @color)
  end

  def possible_moves
    possible_moves = []
    @board.grid.each_with_index do |row, x|
      row.each_with_index do |tile, y|
        possible_moves << [x,y] if valid_move?([x,y])
      end
    end
    possible_moves
  end

  def move(move)
    @board[move[0], move[1]] = self
    @board[@location[0], @location[1]] = nil
    @location = move
    @moved = true
  end

  def valid_move?(move)
    (@board[move[0], move[1]] == nil) || (@board[move[0], move[1]].color != @color)
  end

end