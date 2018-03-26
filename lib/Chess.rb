class Chess
  
  def initialize
    @player1 = "Whites"
    @player2 = "Blacks"
    @board = {}
    @current_player = @player1
    @current_selection = nil
  end

  def start_game
  	#create_board
    #print_board
    
    #loop do
      puts "It's #{@current_player}'s turn"
      puts "Select a piece"
      #input = gets.chomp
      #select_piece(input)
      puts "Select destination"
      #input = gets.chomp
      #move_to(input)
      #king_alive?
      #is_check?
      #is_checkmate?
      #print_board
      #next_turn
    #end

  end

  def create_board
  
  end

  def check_input

  end

  def select_piece

  end

  def save_state

  end

  def load_state

  end

  def main_menu

  end

  class WhitePawn
  end

  class BlackPawn
  end

  class Rook
  end

  class Knight
  end

  class Bishop
  end

  class Queen
  end

  class King
  end

end