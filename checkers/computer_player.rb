require_relative 'player'

class ComputerPlayer < Player
  def initialize(name, color, board)
    super(name)
    @color = color
    @board = board
  end
  
  def get_move_sequence
    # debugger
    pieces = @board.pieces(@color)
    moves = get_jumping_move(pieces)
    moves = continue_jump(moves) if moves

    moves = get_sliding_move(pieces) unless moves
    moves
  end
  
  def get_jumping_move(pieces)
    pieces.each do |piece|
      if piece.jumps.any?
        move = [piece.location, piece.jumps.sample]
        return move
      end
    end
    nil
  end
  
  def continue_jump(moves)
    test_board = @board.dup
    test_board[*moves[0]].perform_jump(moves[-1])

    while !test_board[*moves[-1]].nil? && test_board[*moves[-1]].jumps.any?
      jump = test_board[*moves[-1]].jumps.sample
      moves << jump
      test_board[*moves[-2]].perform_jump(moves[-1])
    end
    return moves
  end
  
  def get_sliding_move(pieces)
    piece = pieces.select { |piece| piece.slides.any? }.sample
    move = [piece.location, piece.slides.sample]
  end
end