#!/usr/bin/env ruby

require_relative 'board'
require_relative 'human_player'

class Chess
  def self.create_game
    player1 = HumanPlayer.new('Player1')
    player2 = HumanPlayer.new('Player2')
    board = Board.setup_default

    Chess.new(player1, player2, board).play
  end

  def initialize(player1, player2, board)
    @board = board
    @players = {:blue => player1, :red => player2}
    @current_player = :blue
  end

  def play
    until over?
      puts "\n" * 2

      @board.display

      if @board.in_check?(@current_player)
        puts "#{@players[@current_player].name}'s king is in check"
      end

      play_turn

      begin
        (@board.grid[0] + @board.grid[7]).each do |piece|
          if piece.is_a? Pawn
            promotion = @players[@current_player].get_promotion
            promote(piece, promotion)
          end
        end
      rescue ArgumentError => e
        puts "#{e.message}"
        retry
      end

      switch_player
    end
    end_game_message
  end

  def play_turn
    begin
      puts "#{@players[@current_player].name}'s turn (#{@current_player})"
      from, to = @players[@current_player].get_move
      from, to = translate_move(from, to)

      @board.make_move(from, to, @current_player)
    rescue ArgumentError => e
      puts "#{e.message}"
      retry
    end
  end

  def over?
    @board.checkmate?(:blue) || @board.checkmate?(:red)
  end

  def end_game_message
    winner = @board.checkmate?(:blue) ? :red.to_s : :blue.to_s
    @board.display
    puts "Game over. Winner is #{winner}"
  end

  def switch_player
    @current_player = @current_player == :red ? :blue : :red
  end

  def translate_move(from, to)
    coords = []
    [from, to].each do |chess_coord|
      chess_coord = chess_coord.reverse.split('')
      coords << chess_coord.map do |char|
        if char.between?('a', 'h')
          char.ord - 97
        else
          8 - char.to_i
        end
      end
    end

    coords
  end

  def promote(piece, promotion)
    new_piece = Kernel.const_get(promotion).new(@board, piece.location, @current_player)
    @board[*piece.location] = new_piece
  end
end

if __FILE__ == $PROGRAM_NAME
  Chess.create_game
end