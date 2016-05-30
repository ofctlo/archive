require_relative 'piece'

class Pawn < Piece

  def initialize(board, location, color)
    super(board, location, color)
    # color implies homerow and direction.
    if @color == :blue
      @direction = -1
      @home_row = 6
    elsif @color == :red
      @direction = 1
      @home_row = 1
    end
  end

  def valid_move?(move)
    return false unless super(move)

    dx = move[0] - @location[0]
    dy = move[1] - @location[1]

    # Capture
    if dy.abs == 1 && dx == @direction
      !@board[move[0], move[1]].nil?
    elsif dx == @direction * 2 && dy == 0 && @board[move[0], move[1]].nil? && @board[move[0] + 1, move[1]].nil?
      # First move x 2. If you don't check for the 2 jump is to a nil spot, checkmate fails
      @location[0] == @home_row
    else
      # Regular move
      # Second test to prevent forward capture.
      dx == @direction && dy == 0 && @board[move[0], move[1]].nil?
    end
  end

  def to_s
    "P".send(@color)
  end
end