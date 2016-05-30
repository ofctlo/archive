#!/usr/bin/env ruby
require_relative 'player'
require_relative 'human_player'
require_relative 'computer_player'
require_relative 'board'

class Checkers
  def self.human_v_computer
    board = Board.new
    Checkers.new(HumanPlayer.new('Player1'),
                 ComputerPlayer.new('Player2', :blue, board),
                 board).play
  end
  
  def self.computer_v_computer
    board = Board.new 
    Checkers.new(ComputerPlayer.new('Player1', :red, board),
                 ComputerPlayer.new('Player2', :blue, board),
                 board).play
  end
  
  def self.human_v_human
    Checkers.new(HumanPlayer.new('Player1'), 
                 HumanPlayer.new('Player2'), 
                 Board.new).play
  end
  
  def initialize(player1, player2, board)
    @players = { :red => player1, :blue => player2 }
    @current_player = :red
    @board = board
  end
  
  def play
    until @board.winner?
      @board.display
      puts "#{@players[@current_player].name}'s (#{@current_player}) turn:"
      moves = @players[@current_player].get_move_sequence
      switch_turn if @board.perform_moves(moves)
    end
    
    end_message
  end
  
  def switch_turn
    @current_player = @current_player == :red ? :blue : :red
  end
  
  def end_message
    puts "The winner was #{@players[@board.winner?].name}!"
  end
end

if __FILE__ == $PROGRAM_NAME
  if ARGV.length == 2
    game_type = "#{ARGV.shift}_v_#{ARGV.shift}"
  else
    game_type = "human_v_computer"
  end
  
  Checkers.send(game_type)
end