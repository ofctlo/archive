require 'colored'

class Piece
  # @board is set by a duped board after duping.
  # @king is set on a duped piece by this piece.
  attr_accessor :board, :king
  # So we can check we aren't jumping our pieces.
  attr_reader :color, :location
  
  def initialize(board, location, color)
    @board, @location, @color = board, location, color
    @direction = @color == :red ? -1 : 1
    # REV: King could be passed in the params with default = false
    # That would save having to set it manually one line later.
    @king = false
  end
  
  # This is the method that should be called to perform
  # a series of moves. (Not perform_moves!)!
  def perform_moves(sequence)
    if valid_move_sequence?(sequence)
      perform_moves!(sequence) 
      return true
    else
      return false
    end
  end
  
  def moves
    slides + jumps
  end
  
  # ●
  # BLACK CIRCLE
  # Unicode: U+25CF
  # ◎
  # BULLSEYE
  # Unicode: U+25CE
  def to_s
    (@king ? "\u25CF " : "\u25CE ").send("#{@color}_on_black")
  end
  
  def dup
    piece_copy = Piece.new(@board, @location, @color)
    # REV: See comment in initialize.
    piece_copy.king = @king
    piece_copy
  end
  
  # Generates valid sliding moves.
  def slides
    slides = Array.new
    move_dirs = slide_dirs

    move_dirs.length.times do |i|
      new_loc = [@location[0] + move_dirs[i][0], 
                 @location[1] + move_dirs[i][1]]
    
      next unless @board.valid_location?(*new_loc)
      slides << new_loc if @board[*new_loc].nil?
    end
  
    slides
  end

  # Generates valid jumping moves.
  def jumps
    jumps = Array.new
    move_dirs = jump_dirs
    jumped_dirs = slide_dirs # The spaces to be jumped over.

    move_dirs.length.times do |i|
      new_loc = [@location[0] + move_dirs[i][0],
                 @location[1] + move_dirs[i][1]]
      jumped_loc = [@location[0] + jumped_dirs[i][0],
                    @location[1] + jumped_dirs[i][1]]
                  
      next unless @board.valid_location?(*new_loc)
      jumps << new_loc if !@board[*jumped_loc].nil? &&
                                @board[*jumped_loc].color != @color &&
                                @board[*new_loc].nil?
    end

    jumps                        
  end
  
  # Perform jump needs to be public so computer AI works.
  # Perform slide moved here for consistency.
  def perform_slide(move)
    raise IllegalMoveError.new unless slides.include? move

    perform_move(move)
  end

  # Computer needs ability to execute partial sequences.
  def perform_jump(move)
    raise IllegalMoveError.new unless jumps.include? move
    jumped_loc = move.dup
    jumped_loc[0] = jumped_loc[0] > @location[0] ? jumped_loc[0] - 1 : 
                                                   jumped_loc[0] + 1
    jumped_loc[1] = jumped_loc[1] > @location[1] ? jumped_loc[1] - 1 :
                                                   jumped_loc[1] + 1
    @board.remove_piece(jumped_loc)
    perform_move(move)
  end
  
protected
  
  # Used both to test if a sequence is valid (duped board)
  # and make actual moves if the sequence is valid (@board)
  def perform_moves!(sequence)
    king_before_moves = @king
    jumping = false
    sliding = false
    sequence.each do |move|
      if slides.include? move
        raise IllegalMoveError.new("Must jump when available") if jumps.any?
        raise IllegalMoveError.new("Can't perform multiple slides") if sliding
        perform_slide(move)
        sliding = true
      elsif jumps.include? move
        perform_jump(move)
        jumping = true
      else
        raise IllegalMoveError.new("Illegal move in sequence")
      end
    end
    # If jumps are available and we are jumping
    # the jumps must be made. We cannot stop here.
    # A king cannot continue jumping immediately after being kinged.
    if jumping && jumps.any? && (!in_end_row? || king_before_moves)
      raise IllegalMoveError.new("Must finish jumping sequence")
    end
  end

private

  def valid_move_sequence?(sequence)
    test_board = @board.dup
    begin
      test_board[*@location].perform_moves!(sequence)
    rescue IllegalMoveError => e
      puts e
      false
    else
      true
    end
  end

  # Does the heavy lifting of moving the piece (self).
  def perform_move(move)
    @board[*move] = self
    @board[*@location] = nil
    @location = move
    @king = true if in_end_row?
    move
  end
  
  def in_end_row?
    (@location[0] == 0 && @color == :red) ||
    (@location[0] == 7 && @color == :blue)
  end


  def slide_dirs
    slide_dirs = [[@direction, @direction],
                  [@direction, -@direction]]
    slide_dirs += [[-@direction, @direction],
                   [-@direction, -@direction]] if @king
    slide_dirs
  end


  def jump_dirs
    jump_dirs = [[@direction * 2, @direction * 2],
                 [@direction * 2, -@direction * 2]]
    jump_dirs += [[-@direction * 2, @direction * 2],
                  [-@direction * 2, -@direction * 2]] if @king
    jump_dirs
  end
end


class IllegalMoveError < ArgumentError
  def initialize(msg = "Illegal move")
    super(msg)
  end
    
end