require_relative 'piece'

class SteppingPiece < Piece

  def initialize(board, location, color, step)
    super(board, location, color)
    @step = step
  end

  def valid_move?(move)
    return false unless super(move)
    dx = move[0] - @location[0]
    dy = move[1] - @location[1]
    @step.include?([dx, dy])
  end
end

class Knight < SteppingPiece
  MOVES = [[1, -2], [1, 2], [2, -1], [2, 1], [-1, 2], [-1, -2], [-2, -1], [-2, 1]]

  def initialize(board, location, color)
    super(board, location, color, MOVES)
  end

  def to_s
    "N".send(@color)
  end
end

class King < SteppingPiece
  MOVES = [[1, 1], [1, 0], [0, 1], [-1, -1], [-1, 1], [-1, 0], [0, -1], [1, -1]]

  def initialize(board, location, color)
    super(board, location, color, MOVES)
  end

  def to_s
    "K".send(@color)
  end

  def valid_move?(move)
    dy = move[1] - @location[1]
    dx = move[0] - @location[0]

    # Castling.
    # debugger if dy.abs == 2
    if dy.abs == 2 && dx == 0 && !@board.in_check?(@color)
      queenside_rook = @board[@location[0], 0]
      kingside_rook = @board[@location[0], 7]
      rook_to_move = nil
      where_rook = nil
      queenside_locs = [[@location[0], @location[1] - 1],
                        [@location[0], @location[1] - 2]]
      kingside_locs = [[@location[0], @location[1] + 1],
                        [@location[0], @location[1] + 2]]
      valid = false
      if dy == -2
        valid = check_castling(queenside_rook, queenside_locs)
        rook_to_move = queenside_rook
        where_rook = queenside_locs[0]
      elsif dy == 2
        valid = check_castling(kingside_rook, kingside_locs)
        rook_to_move = kingside_rook
        where_rook = kingside_locs[0]
      end

      if valid
        @board.make_move(rook_to_move.location, where_rook ,@color)
      end

      return valid
    end

    # Prevent kings from occupying adjacent squares.
    kings = @board.find_king
    red_king = kings[:red]
    blue_king = kings[:blue]

    return false if (red_king[0] - blue_king[0]).abs == 1 ||
                    (red_king[1] - blue_king[1]).abs == 1

    super(move)
  end

  def check_castling(rook, intermediate_locs)
    if !self.moved? && !rook.nil? && !rook.moved?
      # Return here if one of the intermediate positions puts
      # the king in check.
      return false if intermediate_locs.any? do |location|
        copy = @board.dup
        copy[*copy.find_king[@color]] = nil # Kill old king
        copy[*location] = King.new(copy, location, @color)
        copy.in_check?(@color)
      end
      return true # Good to go: Castling!
    end
    false # One of the pieces has moved already.
  end

end