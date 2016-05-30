require_relative 'piece.rb'
require_relative 'stepping_piece.rb'
require_relative 'sliding_piece.rb'
require_relative 'pawn.rb'

class Board
  def self.setup_default
    board = Board.new
    board.setup_pieces

    board
  end

  def initialize(grid = Array.new(8) { Array.new(8) { nil } })
    @grid =  grid
  end

  def setup_pieces
    @grid[0] = create_back_row(:red)
    @grid[1] = create_front_row(:red)
    @grid[7] = create_back_row(:blue)
    @grid[6] = create_front_row(:blue)
  end

  def grid
    @grid.map do |row|
      row.dup
    end
  end

  def dup
    board_copy = Board.new
    @grid.each_with_index do |row, x|
      row.each_with_index do |piece, y|
        board_copy[x, y] = piece.dup(board_copy) unless piece.nil?
      end
    end
    board_copy
  end

  def [](x, y)
    @grid[x][y]
  end

  def []=(x, y, value)
    @grid[x][y] = value
  end

  def make_move(from, to, color)
    piece = self[*from]

    if self[*from].nil?
      raise ArgumentError.new "Invalid move: no piece at move location"
    elsif color != self[*from].color
      raise ArgumentError.new "Invalid move: can't move opponent's piece"
    elsif !piece.valid_move?(to)
      raise ArgumentError.new "Invalid move: move not allowed"
    elsif endangers_king?(from, to)
      raise ArgumentError.new "Invalid move: cannot put your king in check"
    end

    piece.move(to)
  end

  def off_board?(x, y)
    !x.between?(0, @grid.length - 1) || !y.between?(0, @grid[0].length - 1)
  end

  def display
    puts render
  end

  def in_check?(color)
    king_location = find_king[color]
    @grid.each do |row|
      row.each do |tile|
        next if tile.nil? || tile.is_a?(King)
        return true if tile.possible_moves.include?(king_location)
      end
    end
    false
  end

  def checkmate?(color)
    @grid.each_with_index do |row, x|
      row.each_with_index do |tile, y|
        next if tile.nil? || tile.color != color
        tile.possible_moves.each do |move|
          return false if !endangers_king?([x, y], move)
        end
      end
    end
    true
  end

  def find_king
    answer = {}
    @grid.each_with_index do |row, x|
      row.each_with_index do |tile, y|
        next if tile.nil?
        answer[tile.color] = [x, y] if tile.is_a?(King)
      end
    end
    answer
  end

  private

  def create_front_row(color)
    x = color == :red ? 1 : 6
    front_row = Array.new(8)
    front_row.each_index do |i|
      front_row[i] = Pawn.new(self, [x, i], color)
    end

    front_row
  end

  def create_back_row(color)
    x = color == :red ? 0 : 7
    back_row = []
    back_row << Rook.new(self, [x, 0], color)
    back_row << Knight.new(self, [x, 1], color)
    back_row << Bishop.new(self, [x, 2], color)
    back_row << Queen.new(self, [x, 3], color)
    back_row << King.new(self, [x, 4], color)
    back_row << Bishop.new(self, [x, 5], color)
    back_row << Knight.new(self, [x, 6], color)
    back_row << Rook.new(self, [x, 7], color)

    back_row
  end

  def render
    rendered_board = [('a'..'h').to_a.join("|")]
    rendered_board << "\n"
    rendered_board << ["-"] * 16
    rendered_board << "\n"
    @grid.each_with_index do |row, i|
      rendered_row = []
      row.each do |tile|
        if tile.nil?
          rendered_row << "_"
        else
          rendered_row << tile.to_s
        end
      end
      rendered_row << "#{8 - i}"
      rendered_row << "\n"
      rendered_board << rendered_row.join("|")
    end
    rendered_board << ["-"] * 16
    rendered_board.join("")
  end

  def endangers_king?(start, proposed_move)
    next_move_board = self.dup
    color = next_move_board[*start].color
    next_move_board[*start].move(proposed_move)

    next_move_board.in_check?(color)
  end
end

