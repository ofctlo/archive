require_relative 'piece'

class SlidingPiece < Piece
  def initialize(board, location, color, directions)
    super(board, location, color)
    @directions = directions
  end

  def valid_move?(move)
    return false unless super(move)

    @directions.each do |direction|
      next if incorrect_direction?(move, direction)

      x, y = @location
      to_x, to_y = move

      until @board.off_board?(x, y) ||
            (@board[x, y] && @board[x, y] != self) ||
            (x == to_x && y == to_y)

        x += direction[0]
        y += direction[1]
      end
      return true if (x == to_x && y == to_y)
    end
    false
  end

  def incorrect_direction?(move, direction)
    from_x, from_y = @location
    to_x, to_y = move

    ((to_x - from_x) * direction[0] < 0) || # dx opposite of direction
    ((to_y - from_y) * direction[1] < 0) || # dy opposite of direction
    ((to_x - from_x) == 0 && direction[0] != 0) || # dx=0, direction diagonal
    ((to_x - from_x) != 0 && direction[0] == 0) || # mv is diag, dir is straight
    ((to_y - from_y) == 0 && direction[1] != 0) || # dy=0, direction diagonal
    ((to_y - from_y) != 0 && direction[1] == 0) # mv is diag, dir is straight
  end
end

class Bishop < SlidingPiece
  def initialize(board, location, color)
    super(board, location, color, [[1,1], [-1, 1], [-1, -1], [1, -1]])
  end

  def to_s
    "B".send(@color)
  end
end

class Rook < SlidingPiece
  def initialize(board, location, color)
    super(board, location, color, [[1,0], [0, 1], [-1, 0], [0, -1]])
  end

  def to_s
    "R".send(@color)
  end
end

class Queen < SlidingPiece
  def initialize(board, location, color)
    super(board, location, color, [[1,0], [0, 1], [-1, 0], [0, -1],
                  [1,1], [-1, 1], [-1, -1], [1, -1]])
  end

  def to_s
    "Q".send(@color)
  end
end