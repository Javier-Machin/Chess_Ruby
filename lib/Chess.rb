class Chess
  attr_accessor :board
  
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
  	@board["a8"] = Rook.new("Blacks")
    @board["b8"] = Knight.new("Blacks")
    @board["c8"] = Bishop.new("Blacks")
    @board["d8"] = Queen.new("Blacks")
    @board["e8"] = King.new("Blacks")
    @board["f8"] = Bishop.new("Blacks")
    @board["g8"] = Knight.new("Blacks")
    @board["h8"] = Rook.new("Blacks") 
  	8.times { |index| @board["#{(index + 97).chr}7"] = BlackPawn.new("Blacks") }
    8.times { |index| @board["#{(index + 97).chr}6"] = nil }
    8.times { |index| @board["#{(index + 97).chr}5"] = nil }
    8.times { |index| @board["#{(index + 97).chr}4"] = nil }
    8.times { |index| @board["#{(index + 97).chr}3"] = nil }
    8.times { |index| @board["#{(index + 97).chr}2"] = WhitePawn.new("Whites") }
    @board["a1"] = Rook.new("Whites") 
    @board["b1"] = Knight.new("Whites")
    @board["c1"] = Bishop.new("Whites")
    @board["d1"] = Queen.new("Whites")
    @board["e1"] = King.new("Whites")
    @board["f1"] = Bishop.new("Whites")
    @board["g1"] = Knight.new("Whites")
    @board["h1"] = Rook.new("Whites")
  end

  def print_board
    @board.each do |key, value|
      if key[0] == "h"
        value == nil ? (puts "[  ]") : (puts "[#{value.symbol} ]")
      elsif key[0] == "a"
        value == nil ? (print "#{key[1]} [  ]") : (print "#{key[1]} [#{value.symbol} ]")
      else
        value == nil ? (print "[  ]") : (print "[#{value.symbol} ]") 
      end
    end
    puts "   a   b   c   d   e   f   g   h"
  end

  def check_input(input, type)
  	#type piece
  	#type destination
    #what is done here and what is done in select_piece?
  end

  def select_piece
    #everytime a piece is selected a list of possible destinations for that piece is created
    #method that creates the list is named the same in every piece class so call reusable
  end

  def move_to(destination)
    #gucci if destination included in the list of possible destinations
  end

  def save_state
    #check hangman
  end

  def load_state
    #check hangman
  end

  def main_menu
    #1 start new game
    #2 load game
  end

  class Piece
    attr_accessor :team, :symbol 
    def initialize(team)
  	  @team = team
  	end
  end

  class WhitePawn < Piece
  	def initialize(team)
  	  super	
  	  @symbol = "\u265F".encode("utf-8")  
  	end
  end

  class BlackPawn < WhitePawn
  	def initialize(team)
  	  super
  	  @symbol = "\u2659".encode("utf-8")
  	end
  end

  class Rook < Piece
    def initialize(team)
      super
      team == "Whites" ? @symbol = "\u265C".encode("utf-8") :
                         @symbol = "\u2656".encode("utf-8")
    end
  end

  class Knight < Piece
    def initialize(team)
      super
      team == "Whites" ? @symbol = "\u265E".encode("utf-8") : 
                         @symbol = "\u2658".encode("utf-8")
    end
  end

  class Bishop < Piece
    def initialize(team)
      super
      team == "Whites" ? @symbol = "\u265D".encode("utf-8") :
                         @symbol = "\u2657".encode("utf-8")
    end
  end

  class Queen < Piece
    def initialize(team)
      super
      team == "Whites" ? @symbol = "\u265B".encode("utf-8") :
                         @symbol = "\u2655".encode("utf-8")
    end
  end

  class King < Piece
    def initialize(team)
      super
      team == "Whites" ? @symbol = "\u265A".encode("utf-8") :
                         @symbol = "\u2654".encode("utf-8")
    end
  end

end

muh_chess = Chess.new
muh_chess.create_board
muh_chess.print_board
puts muh_chess.board["a1"]
puts muh_chess.board["a1"].team