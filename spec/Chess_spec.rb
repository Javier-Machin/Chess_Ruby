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
         expect(my_game.board["12"]).to eql(nil)
      end
    end
  end
end