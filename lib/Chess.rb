class Chess
  attr_accessor :board
  
  def initialize
    @player1 = "Whites"
    @player2 = "Blacks"
    @board = {}
    @current_player = @player1
    @current_opponent = @player2
    @current_selection = nil
    @possible_moves = []
    @x = 1
    @y = 1
  end

  def convert_input(input)
    x = input[0].ord - 96
    y = input[1]
    return "#{x}#{y}"
  end

  def start_game
    create_board
    print_board
    
    loop do
      puts "It's #{@current_player}'s turn"
      puts "Select a piece"
      input = gets.chomp
      input = convert_input(input)
      select_piece(input)
      puts "Select destination"
      input = gets.chomp
      input = convert_input(input)
      move_to(input)
      #king_alive?
      #is_check?
      #is_checkmate?
      print_board
      next_turn
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
      if key[0] == "8"
        value == nil ? (puts "[  ]") : (puts "[#{value.symbol} ]")
      elsif key[0] == "1"
        value == nil ? (print "#{key[1]} [  ]") : (print "#{key[1]} [#{value.symbol} ]")
      else
        value == nil ? (print "[  ]") : (print "[#{value.symbol} ]") 
      end
    end
    puts "   a   b   c   d   e   f   g   h"
  end

  def check_input(input, type)

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
    loop do
      if @board[input] == nil
        puts "That slot is empty" 
      elsif @board[input].team == @current_player
        piece = @board[input].class.to_s.split("::")[-1]
        puts "#{piece} selected"
        @current_selection = input
        calculate_moves(piece, input)
        break
      else
        puts "Invalid selection, wrong team"
      end
      puts "select a piece"
      input = gets.chomp[0, 2]
      input = convert_input(input)
    end
  end

  #Using the class and the current location, create a list of the possible movements
  def calculate_moves(piece, location)
    @x = location[0].to_i
    @y = location[1].to_i
    @possible_moves = []

    case piece

    when "WhitePawn"
      #move = "#{@x + 1}#{@y + 1}" <--- brah
      # 1 step forward
      @possible_moves << "#{@x}#{@y + 1}" unless @board["#{@x}#{@y + 1}"] != nil 
      
      # Attack forward right
      if @board["#{@x + 1}#{@y + 1}"] != nil && 
      	 @board["#{@x + 1}#{@y + 1}"].team == @current_opponent 
        
        @possible_moves << "#{@x + 1}#{@y + 1}" 
      end
      
      # Attack forward left
      if @board["#{@x - 1}#{@y + 1}"] != nil && 
         @board["#{@x - 1}#{@y + 1}"].team == @current_opponent 
        
        @possible_moves << "#{@x - 1}#{@y + 1}" 
      end
      
      # 2 steps forward if its in the starting point
      @possible_moves << "#{@x}#{@y + 2}" unless @y != 2 || path_blocked?("#{@x}#{@y + 2}") ||
                                                            @board["#{@x}#{@y + 2}"] != nil

    when "BlackPawn"
      # Same moves of the WhitePawn but reversed
      @possible_moves << "#{@x}#{@y - 1}" unless @board["#{@x}#{@y - 1}"] != nil 

      if @board["#{@x + 1}#{@y - 1}"] != nil && 
      	 @board["#{@x + 1}#{@y - 1}"].team == @current_opponent
        
        @possible_moves << "#{@x + 1}#{@y - 1}" 
      end

      if @board["#{@x - 1}#{@y - 1}"] != nil && 
      	 @board["#{@x - 1}#{@y - 1}"].team == @current_opponent
        
        @possible_moves << "#{@x - 1}#{@y - 1}" 
      end

      @possible_moves << "#{@x}#{@y - 2}" unless @y != 7 || path_blocked?("#{@x}#{@y - 2}") ||
                                                            @board["#{@x}#{@y - 2}"]

    when "Rook"
      7.times do |index|
      	move = "#{@x + (index + 1)}#{@y}"
        @possible_moves << move unless path_blocked?(move) || out_of_bounds?(move) || friendly_piece?(move)
        move = "#{@x}#{@y + (index + 1)}"
        @possible_moves << move unless path_blocked?(move) || out_of_bounds?(move) || friendly_piece?(move)
      end
      7.times do |index|
      	move = "#{@x - (index + 1)}#{@y}"
        @possible_moves << move unless path_blocked?(move) || out_of_bounds?(move) || friendly_piece?(move)
        move = "#{@x}#{@y - (index + 1)}"
        @possible_moves << move unless path_blocked?(move) || out_of_bounds?(move) || friendly_piece?(move)
      end     
    when "Knight"
      knight_moves = [[@x + 1, @y + 2], [@x + 2, @y + 1], 
                      [@x + 2, @y - 1], [@x + 1, @y - 2], 
                      [@x - 1, @y - 2], [@x - 2, @y - 1], 
                      [@x - 2, @y + 1], [@x - 1, @y + 2]]
      
      knight_moves.each do |move| 
        @possible_moves << "#{move[0]}#{move[1]}" unless out_of_bounds?("#{move[0]}#{move[1]}") ||
                                                        friendly_piece?("#{move[0]}#{move[1]}")
      end        
    when "Bishop"
      7.times do |index|
      	move = "#{@x + (index + 1)}#{@y + (index + 1)}"
        @possible_moves << move unless path_blocked?(move) || out_of_bounds?(move) || friendly_piece?(move)
        move = "#{@x - (index + 1)}#{@y - (index + 1)}"
        @possible_moves << move unless path_blocked?(move) || out_of_bounds?(move) || friendly_piece?(move)
      end
      7.times do |index|
      	move = "#{@x + (index + 1)}#{@y - (index + 1)}"
        @possible_moves << move unless path_blocked?(move) || out_of_bounds?(move) || friendly_piece?(move)
        move = "#{@x - (index + 1)}#{@y + (index + 1)}"
        @possible_moves << move unless path_blocked?(move) || out_of_bounds?(move) || friendly_piece?(move)
      end   

    when "Queen"

    when "King"
    
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

  def path_blocked?(target)
    #checks every slot in the path from the original location to the target
    #returns true if it finds anything but empty slots in the path

    x_steps = target[0].to_i - @x
    y_steps = target[1].to_i - @y
    if @board[@current_selection].class.to_s.include?("Pawn") || @board[@current_selection].class.to_s.include?("Rook")
      (y_steps.abs - 1).times do |index| #maybe will need (y_steps.abs - 1) to check the path up to the target but not included
        if y_steps > 0
          current_target = @y + (index + 1)
          return true if @board["#{target[0]}#{current_target}"] != nil
        elsif y_steps < 0
          current_target = @y - (index + 1)
          return true if @board["#{target[0]}#{current_target}"] != nil
        end
      end
      (x_steps.abs - 1).times do |index| #maybe will need (y_steps.abs - 1) to check the path up to the target but not included
        if x_steps > 0
          current_target = @x + (index + 1)
          return true if @board["#{current_target}#{target[1]}"] != nil
        elsif x_steps < 0
          current_target = @x - (index + 1)
          return true if @board["#{current_target}#{target[1]}"] != nil
        end
      end
    else
      #bishop rules
      (y_steps.abs - 1).times do |index| #maybe will need (y_steps.abs - 1) to check the path up to the target but not included
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
    end
    false
  end

  def friendly_piece?(target)
    if @board[target] != nil
      return true if @board[target].team == @current_player
    end
  end

  def move_to(destination)
    #gucci if destination included in the list of possible destinations
    #or change selection if destination friendly piece
    loop do 
      if @possible_moves.include?(destination)
        @board[destination] = @board[@current_selection]
        @board[@current_selection] = nil
        break
      else
        puts "Invalid move, enter a different target location"
      end
      destination = gets.chomp[0, 2]
      destination = convert_input(destination)
    end
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
muh_chess.start_game