require 'colored'
require_relative 'piece'

class Board
  def initialize(grid = Array.new(8) { Array.new(8) { nil } })
    @grid = grid
    @pieces = Array.new
    # If this board was created non-empty, need to find pieces.
    if @grid.any? { |row| row.any? { |piece| !piece.nil? } }
      find_pieces
    else
      initial_setup
    end
  end
  
  def [](x, y)
    @grid[x][y]
  end
  
  def []=(x, y, val)
    @grid[x][y] = val
  end
  
  def dup
    board_copy = Board.new(grid)
  end
  
  def grid
    @grid.map { |row| row.map { |piece| piece.nil? ? nil : piece.dup } }
  end
  
  def pieces(color)
    @pieces.select { |piece| piece.color == color }.map(&:dup)
  end
  
  def valid_location?(x, y)
    x.between?(0, @grid.length - 1) && y.between?(0, @grid[0].length - 1)
  end
  
  def perform_moves(sequence)
    if self[*sequence[0]].nil?
      puts "No piece at location given"
      return false
    else
      return self[*sequence[0]].perform_moves(sequence[1..-1])
    end
  end
  
  def remove_piece(loc)
    @pieces.delete(self[*loc])
    self[*loc] = nil
  end
  
  def winner?
    return :blue if @pieces.none? { |piece| piece.color == :red }
    return :red if @pieces.none? { |piece| piece.color == :blue }
    false
  end
  
  def display
    puts render
  end
  
  private
  
  def initial_setup
    setup_team(:blue, 0)
    setup_team(:red, 5)
  end
  
  # Start row is the lowest indexed row on which the player
  # has starting pieces (0 for black, 5 for white).
  def setup_team(color, start_row)
    3.times do |row|
      row += start_row
      @grid[row].each_with_index do |space, col|
        next if (row.even? && col.even?) || (row.odd? && col.odd?)
        space = Piece.new(self, [row, col], color)
        self[row, col] = space
        @pieces << space
      end
    end
  end
  
  # When a board is duped it won't know the location of pieces.
  def find_pieces
    @grid.each do |row|
      row.each do |piece|
        next if piece.nil?
        @pieces << piece
        piece.board = self
      end
    end
  end
  
  
  # Inactive spaces are the white background spaces that aren't used.
  def inactive_space?(x, y)
    (x.even? && y.even?) || (x.odd? && y.odd?)
  end
  
  
  def render
    labels = "  #{(0..7).to_a.join(' ')}"
    rendered_board = [labels]
    @grid.each_with_index do |row, x|
      rendered_row = ["#{x}"]
      row.each_with_index do |piece, y|
        background = inactive_space?(x, y) ? :white : :black
        rendered_row[y + 1] = self[x, y].nil? ? '  '.send("blue_on_#{background}") : self[x, y]
      end
      rendered_row << "#{x}"
      rendered_board << rendered_row.join('')
    end
    rendered_board << labels
    rendered_board.join("\n")
  end
end