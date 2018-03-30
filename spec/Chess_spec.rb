require "Chess"

describe Chess do
  subject(:my_game) { Chess.new }    

  describe "attributes" do
    
    context "with game instance created" do
      it { is_expected.to respond_to(:board) }
    end

  end

  describe "move_to" do

    context "when given correct possible moves" do
	  	 
      it "moves the selected piece" do
        my_game.create_board 
        my_game.select_piece("12")
        my_game.move_to("14")    
        expect(my_game.board["14"].class).to eql(Chess::WhitePawn) 
      end

      it "removes the selected piece from the original location" do
        my_game.create_board 
        my_game.select_piece("12")
        my_game.move_to("14")  
        expect(my_game.board["12"]).to eql(nil)
      end

      it "works with black pieces too" do
        my_game.create_board
        my_game.next_turn
        my_game.select_piece("17")
        my_game.move_to("15")
        expect(my_game.board["15"].class).to eql(Chess::BlackPawn) 
      end

      it "allow Knights to jump over other pieces" do
        my_game.create_board
        my_game.select_piece("21")
        my_game.move_to("33")
        expect(my_game.board["33"].class).to eql(Chess::Knight)
      end
      
    end
  end

  describe "is_check?" do 

    context "When a king is in check" do

      it "returns true" do
        my_game.select_piece("41")
        my_game.move_to("48")
        my_game.next_turn
        expect(my_game.is_check?("58")).to eql(true)
      end
    end
  end

  describe "is_checkmate?" do 

    context "When a king is in checkmate" do

      it "returns true" do 
        my_game.select_piece("41")
        my_game.move_to("48")
        my_game.select_piece("48")
        my_game.move_to("38")
        my_game.next_turn
        my_game.current_king_location = "58"
        my_game.is_check?("58")
        expect(my_game.is_checkmate?).to eql(true)
      end
    end
  end

end