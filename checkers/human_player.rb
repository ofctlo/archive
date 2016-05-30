require_relative 'player'

class HumanPlayer < Player
  def get_move_sequence
    input = [nil, nil]
    
    puts "What piece did you want to move?"
    puts "Enter the coordinates as comma separated values"
    
    until valid_coords?(input)
      input = gets.chomp.split(',').map(&:strip)
    end
    
    moves = [input.map(&:to_i)]
    
    puts "Enter your move sequence."
    puts "Comma separated, one x,y pair per line. Blank line to end."
    
    until input == []
      input = input_coords
      next if input == []
      
      if valid_coords?(input)
        moves << input.map(&:to_i)
      else
        puts "Invalid coordinates"
      end
    end
    
    moves
  end
  
  def input_coords
    gets.chomp.split(',').map(&:strip)
  end
  
  def valid_coords?(coords)
    coords.all? { |coord| ('0'..'7').include? coord } && coords.length == 2
  end
end