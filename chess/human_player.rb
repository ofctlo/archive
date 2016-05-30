require_relative 'player'

class HumanPlayer < Player
  def get_move
    puts "Enter your move:"
    move = gets.chomp.split(',').map(&:strip)
    unless move.length == 2
      raise ArgumentError.new "Must enter start and end position"
    end
    unless move[0][0].between?('a', 'h') && move[1][0].between?('a', 'h') &&
           move[0][1].between?('1', '8') && move[1][1].between?('1', '8')
      raise ArgumentError.new "Invalid coordinates"
    end

    move
  end

  def get_promotion
    puts "What do you want to promote your Pawn to?"
    promotion = gets.chomp.downcase
    case promotion
    when 'queen' || 'q'
      :Queen
    when 'knight' || 'n'
      :Knight
    when 'rook' || 'r'
      :Rook
    when 'bishop' || 'b'
      :Bishop
    else
      raise ArgumentError.new "Invalid response"
    end
  end
end