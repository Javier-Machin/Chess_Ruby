require "json"

class Chess
  attr_accessor :board, :current_king_location
  
  def initialize
    @player1 = "Whites"
    @player2 = "Blacks"
    @board = {}
    create_board
    @current_player = @player1
    @current_opponent = @player2
    @current_selection = nil
    @current_king_location = nil
    @possible_moves = []
    @x = 1
    @y = 1
  end

  def convert_input(input)
  	return "exit" if input == "exit"
    x = input[0].ord - 96
    y = input[1]
    return "#{x}#{y}"
  end

  def start_game
    puts "To select a piece or a destination write the coordinates ex:\n" + 
         "b1 to select the left white knight.\n\nYou can enter 'save' to save" + 
         " the current state of the match\nor 'exit' to leave the game.\n\n"

    print_board
 
    loop do
      if is_check?(@current_king_location)      
        puts "YOU ARE IN CHECK!"
        break if is_checkmate? 
      end      	
      puts "\nIt's #{@current_player}'s turn\n\n"
      puts "Select a piece"
      input = gets.chomp
      save_state if input == "save"  
      input = check_input(input, "selection")
      break if input == "exit" 
      select_piece(input)
      puts "Select destination"
      input = gets.chomp
      save_state if input == "save"      
      input = check_input(input)
      break if input == "exit"
      move_to(input)
      next_turn
      print_board 
    end

  end

  def is_check?(king_location)
  	@board.each do |key, value|
  	  if value != nil && value.team == @current_opponent
  	    piece = value.class.to_s.split("::")[-1]
  	    next_turn
  	    calculate_moves(piece, key)
  	    next_turn
  	    return true if @possible_moves.any? { |move| move == king_location}
  	  end
  	end
    false
  end

# Do every possible movement for the king, and confirms it is in check in every position.
  def is_checkmate?
    @current_selection = @current_king_location
    calculate_moves("King", @current_king_location)
    move_out_of_check = @possible_moves.all? do |move|
    	                  board_pre_move = @board.clone
    	                  @board[move] = @board[@current_king_location]
    	                  @board[@current_king_location] = nil
                          if is_check?(move)
                          	@board = board_pre_move
                          	true
                          else
                          	@board = board_pre_move 
                          	false
                          end
                        end
  # In case of the the king being in check in every position, 
  # checks every ally piece possible moves and looks for one where the king isn't in check,
  # returns false if it finds one, otherwise its checkmate
    if move_out_of_check
      #Clone the board original state to use it to undo changes
      board_pre_move = @board.clone	
      board_pre_move.each do |key, value|
        if value != nil && value.team == @current_player && !value.class.to_s.include?("King")
          piece = value.class.to_s.split("::")[-1]
          @current_selection = key 
          calculate_moves(piece, key)
          @possible_moves.each do |move|  
            @board[move] = @board[@current_selection]
            @board[@current_selection] = nil 
            unless is_check?(@current_king_location)
              puts "  not checkmate!"
              #Always undo the changes
              @board[move] = board_pre_move[move]
              @board[@current_selection] = board_pre_move[@current_selection]
              return false
            else
              @board[move] = board_pre_move[move]
              @board[@current_selection] = board_pre_move[@current_selection]	
            end
          end
        end
      end
      puts "  CHECKMATE! #{@current_opponent} Won!"
      true
    end
  end

  def check_input(input, type="")
    input = convert_input(input) unless input == "save"
    if type == "selection"
      loop do
      	if input == "exit"
          return "exit"
        elsif input == "save"
          puts "Game saved"
        elsif @board[input] == nil
          puts "That slot is empty" 
        elsif @board[input].team == @current_player
          return input 
        else
          puts "Invalid selection, wrong team"
        end
        puts "Select a piece"
        input = gets.chomp
        input = convert_input(input)
      end
    else
      loop do 
      	if input == "exit"
      	  return "exit"
      	elsif input == "save"
          puts "Game saved"  
        elsif @possible_moves.include?(input)
          return input
        elsif @board[input] != nil && @board[input].team == @current_player
          select_piece(input)
        else
          puts "Invalid move, enter a different target location"
        end
        puts "Select a destination" 
        input = gets.chomp
        input = convert_input(input)
      end  
    end
  end

  #Populates the board with pieces and empty slots
  def create_board
    @board["18"] = Rook.new("Blacks")
    @board["28"] = Knight.new("Blacks")
    @board["38"] = Bishop.new("Blacks")
    @board["48"] = Queen.new("Blacks")
    @board["58"] = King.new("Blacks")
    @board["68"] = Bishop.new("Blacks")
    @board["78"] = Knight.new("Blacks")
    @board["88"] = Rook.new("Blacks")  
    8.times { |index| @board["#{index + 1}7"] = BlackPawn.new("Blacks") }  

    8.times { |index| @board["#{index + 1}6"] = nil }
    8.times { |index| @board["#{index + 1}5"] = nil }
    8.times { |index| @board["#{index + 1}4"] = nil }
    8.times { |index| @board["#{index + 1}3"] = nil }

    8.times { |index| @board["#{index + 1}2"] = WhitePawn.new("Whites") } 
    @board["11"] = Rook.new("Whites") 
    @board["21"] = Knight.new("Whites")
    @board["31"] = Bishop.new("Whites")
    @board["41"] = Queen.new("Whites")
    @board["51"] = King.new("Whites")
    @board["61"] = Bishop.new("Whites")
    @board["71"] = Knight.new("Whites")
    @board["81"] = Rook.new("Whites")
  end

  def print_board
    @board.each do |key, value|
      @current_king_location = key if value.class.to_s.include?("King") && 
                                      value.team == @current_player
      if key[0] == "8"
        value == nil ? (puts "[  ]") : (puts "[#{value.symbol} ]")
      elsif key[0] == "1"
        value == nil ? (print "#{key[1]} [  ]") :
                       (print "#{key[1]} [#{value.symbol} ]")
      else
        value == nil ? (print "[  ]") : (print "[#{value.symbol} ]") 
      end
    end
    puts "   a   b   c   d   e   f   g   h"
  end

  def next_turn
    if @current_player == "Whites"
      @current_player = "Blacks"
      @current_opponent = "Whites"
    else
      @current_player = "Whites"
      @current_opponent = "Blacks"
    end
  end

  def select_piece(input)
    piece = @board[input].class.to_s.split("::")[-1]
    puts "#{piece} selected"
    @current_selection = input
    calculate_moves(piece, input)
  end

  # Using the class and the current location, 
  # create a list of the possible movements
  def calculate_moves(piece, location)
    @x = location[0].to_i
    @y = location[1].to_i
    @possible_moves = []

    def add_straight_line_moves(index)
      move = "#{@x + (index + 1)}#{@y}" # Right
      @possible_moves << move unless path_blocked?(move) || out_of_bounds?(move) ||
                                                            friendly_piece?(move)
      move = "#{@x}#{@y + (index + 1)}" # Up
      @possible_moves << move unless path_blocked?(move) || out_of_bounds?(move) ||
                                                            friendly_piece?(move)
      move = "#{@x - (index + 1)}#{@y}" # Left
      @possible_moves << move unless path_blocked?(move) || out_of_bounds?(move) ||
                                                            friendly_piece?(move)
      move = "#{@x}#{@y - (index + 1)}" # Down
      @possible_moves << move unless path_blocked?(move) || out_of_bounds?(move) ||
                                                            friendly_piece?(move)
    end

    def add_diagonal_moves(index)
      move = "#{@x + (index + 1)}#{@y + (index + 1)}" # Up right
      @possible_moves << move unless path_blocked?(move) || out_of_bounds?(move) ||
                                                            friendly_piece?(move)
      move = "#{@x - (index + 1)}#{@y - (index + 1)}" # Down left
      @possible_moves << move unless path_blocked?(move) || out_of_bounds?(move) ||
                                                            friendly_piece?(move)
      move = "#{@x + (index + 1)}#{@y - (index + 1)}" # Down right
      @possible_moves << move unless path_blocked?(move) || out_of_bounds?(move) ||
                                                            friendly_piece?(move)
      move = "#{@x - (index + 1)}#{@y + (index + 1)}" # Up left
      @possible_moves << move unless path_blocked?(move) || out_of_bounds?(move) ||
                                                            friendly_piece?(move)
    end

    case piece

    when "WhitePawn"
      # 1 step forward
      move = "#{@x}#{@y + 1}"
      @possible_moves << move unless @board[move] != nil      
      # Attack forward right
      move = "#{@x + 1}#{@y + 1}"
      if @board[move] != nil && @board[move].team == @current_opponent 
        @possible_moves << move 
      end     
      # Attack forward left
      move = "#{@x - 1}#{@y + 1}"
      if @board[move] != nil && @board[move].team == @current_opponent 
        @possible_moves << move 
      end    
      # 2 steps forward if its in the starting point
      move = "#{@x}#{@y + 2}"
      @possible_moves << move unless @y != 2 || path_blocked?(move) ||
                                                @board[move] != nil

    when "BlackPawn"
      # Same moves of the WhitePawn but reversed
      move = "#{@x}#{@y - 1}"
      @possible_moves << move unless @board[move] != nil 
     
      move = "#{@x + 1}#{@y - 1}"
      if @board[move] != nil && @board[move].team == @current_opponent
        @possible_moves << move 
      end
      
      move = "#{@x - 1}#{@y - 1}"
      if @board[move] != nil && @board[move].team == @current_opponent
        @possible_moves << move
      end
      
      move = "#{@x}#{@y - 2}"
      @possible_moves << move unless @y != 7 || path_blocked?(move) || @board[move]

    when "Rook"
      # 7 is the max distance between squares
      # The method is called 7 times to have a list of all possible targets ready
      7.times { |index| add_straight_line_moves(index) }

    when "Knight"
      knight_moves = [[@x + 1, @y + 2], [@x + 2, @y + 1], 
                      [@x + 2, @y - 1], [@x + 1, @y - 2], 
                      [@x - 1, @y - 2], [@x - 2, @y - 1], 
                      [@x - 2, @y + 1], [@x - 1, @y + 2]]
      
      knight_moves.each do |move|
        move = "#{move[0]}#{move[1]}" 
        @possible_moves << move unless out_of_bounds?(move) || friendly_piece?(move)
      end

    when "Bishop"
      7.times { |index| add_diagonal_moves(index) }
    
    when "Queen"
      7.times do |index|
        add_straight_line_moves(index)
        add_diagonal_moves(index)
      end
    
    when "King"
      # The King can move only 1 square away so the methods are called just once
      add_straight_line_moves(0)
      add_diagonal_moves(0)
    else

    end
  end

  def out_of_bounds?(target)
    x = target[0]
    y = target[1]
    return true unless x.to_i.between?(1, 8)
    return true unless y.to_i.between?(1, 8)
    false
  end

  # Checks every slot in the path from the original location to the target
  # Returns true if it finds anything but empty slots in the path
  def path_blocked?(target)
    x_steps = target[0].to_i - @x
    y_steps = target[1].to_i - @y
    # Diagonal movements
    if x_steps != 0 && y_steps != 0
      (y_steps.abs - 1).times do |index| 
        if y_steps > 0 && x_steps > 0
          current_target = "#{@x + (index + 1)}#{@y + (index + 1)}"
          return true if @board[current_target] != nil
        elsif y_steps < 0 && x_steps > 0
          current_target = "#{@x + (index + 1)}#{@y - (index + 1)}"
          return true if @board[current_target] != nil
        elsif y_steps > 0 && x_steps < 0
          current_target = "#{@x - (index + 1)}#{@y + (index + 1)}"
          return true if @board[current_target] != nil
        elsif y_steps < 0 && x_steps < 0
          current_target = "#{@x - (index + 1)}#{@y - (index + 1)}"
          return true if @board["#{target[0]}#{current_target}"] != nil
        end
      end
    # Straight line movements
    else
      (y_steps.abs - 1).times do |index| 
        if y_steps > 0
          current_target = @y + (index + 1)
          return true if @board["#{target[0]}#{current_target}"] != nil
        elsif y_steps < 0
          current_target = @y - (index + 1)
          return true if @board["#{target[0]}#{current_target}"] != nil
        end
      end
      (x_steps.abs - 1).times do |index| 
        if x_steps > 0
          current_target = @x + (index + 1)
          return true if @board["#{current_target}#{target[1]}"] != nil
        elsif x_steps < 0
          current_target = @x - (index + 1)
          return true if @board["#{current_target}#{target[1]}"] != nil
        end
      end
    end
    false
  end

  def friendly_piece?(target)
    if @board[target] != nil
      return true if @board[target].team == @current_player
    end
  end

  def move_to(destination)
    @board[destination] = @board[@current_selection]
    @board[@current_selection] = nil
    return destination
  end

  def save_state
    json_board = {}
    @board.each do |key, value|
      value != nil ? json_board[key] = value.as_json : json_board[key] = nil
    end 
    json_object = { :json_board => json_board, :current_player => @current_player }.to_json
    File.open("saved_state.json", "w") { |file| file.write(json_object) }
  end

  # Sets current_player and reconstruct the board with the saved state values
  def load_state
    begin
      save_file = File.read("saved_state.json")
    rescue
      return "No saved game found"
    end
    json_hash = JSON.parse(save_file)
    json_hash["json_board"].each do |key, value|
      value == nil ? @board[key] = nil : 
                     @board[key] = Chess.const_get(value["class"]).new(value["team"])
    end
    @current_player = json_hash["current_player"]
    return "Game loaded"
  end

  def main_menu
    puts "(1) New game"
    puts "(2) Load game"
    print "Select an option: "
    option = gets.chomp[0]
    puts ""
    puts load_state if option == "2"
    start_game
  end

  class Piece
    attr_accessor :team, :symbol 
    def initialize(team)
      @team = team
    end

    def as_json
      { 
      	:team => @team,
      	:class => self.class.to_s.split("::")[-1]
      }
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

#muh_chess = Chess.new
#muh_chess.main_menu