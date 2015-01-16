require_relative "../rover"

require_relative "../plateau"

# plateau shoul be created
describe Plateau do 
	it "should create an instance of plateau" do 
		@plateau = Plateau.new 5,5
		expect(@plateau).to be_instance_of Plateau
	end

	it "should fail if non-integer coordinates are provided" do 
		expect { Plateau.new 5,"A" }.to raise_error(InvalidInputError)
		expect { Plateau.new "B","A" }.to raise_error(InvalidInputError) 
		expect { Plateau.new "",5 }.to raise_error(InvalidInputError)
	end

	it "should be true if coordinates are out of range" do 
		@plateau = Plateau.new 5,5
		expect(@plateau.out_of_range? 5,6).to eq(true)
		expect(@plateau.out_of_range? 7,2).to eq(true)
		expect(@plateau.out_of_range? 8,8).to eq(true)
		expect(@plateau.out_of_range? -1,-2).to eq(true)
		expect(@plateau.out_of_range? -1,2).to eq(true)
		expect(@plateau.out_of_range? 1,-2).to eq(true)
	end

	it "should be false if coordinates are in plateau range" do 
		@plateau = Plateau.new 5,5
		expect(@plateau.out_of_range? 4,4).to eq(false)
	end

end


describe Rover do 
	it "should return an instance of Rover" do 
		@plateau = Plateau.new 5,5
		@rover = Rover.new 3,4,"N", @plateau
		expect(@rover).to be_instance_of(Rover)
	end

	it "should fail if a non-plateau instance is passed to the rover" do 
		@plateau = Array.new
		expect { Rover.new 3,4, "N",@plateau}.to raise_error(InvalidInputError)
	end

	it "should fail if invalid directions [anything except E W N S] are provided" do 
		@plateau = Plateau.new 5,5
		expect { Rover.new 3,4,"Q", @plateau }.to raise_error(InvalidInputError)
		expect { Rover.new 3,4,"@", @plateau }.to raise_error(InvalidInputError)
	end

	it "should fail if invalid coordinates are provided" do 
		@plateau = Plateau.new 5,5
		expect { Rover.new "A",3,"N", @plateau }.to raise_error(InvalidInputError)
		expect { Rover.new 2,"B","E", @plateau }.to raise_error(InvalidInputError)
		expect { Rover.new "AA","B","W", @plateau }.to raise_error(InvalidInputError)
	end

	it "should fail if rovers are initialized outside the plateau range" do 
		@plateau = Plateau.new 5,5
		expect { Rover.new 6,2, "W", @plateau }.to raise_error(OutOfPlateauRangeError)
	end

	it "should fail while accessing the private methods 'move' and 'turn' on rover" do 
		@plateau = Plateau.new 5,5
		@rover = Rover.new 1 ,2, "W", @plateau
		expect { @rover.move }.to raise_error(NoMethodError)
		expect { @rover.turn }.to raise_error(NoMethodError)
	end

	it "should be able to access 'process_instruction_string' method on rover" do 
		@plateau = Plateau.new 5,5
		@rover = Rover.new 1 ,2, "W", @plateau
		expect(@rover.respond_to?(:process_instruction_string)).to eq(true)
	end

	it "should have only READ access to the 'current_position' and 'directions' attributes on Rover" do 
		@plateau = Plateau.new 5,5
		@rover = Rover.new 1 ,2, "W", @plateau
		expect(@rover.respond_to?(:current_position)).to eq(true)
		expect(@rover.respond_to?(:current_position=)).to eq(false)
		expect(@rover.respond_to?(:directions)).to eq(true)
		expect(@rover.respond_to?(:directions=)).to eq(false)
	end

	it "should have only READ access to the 'upper_limit' attribute on Plateau" do 
		@plateau = Plateau.new 5,5		
		expect(@plateau.respond_to?(:upper_limit)).to eq(true)
		expect(@plateau.respond_to?(:upper_limit=)).to eq(false)
	end

	it "should reject invalid instructions i.e anything other than L,R,M" do 
		@plateau = Plateau.new 5,5
		@rover = Rover.new 1 ,2, "W", @plateau
		expect { @rover.process_instruction_string("W") }.to raise_error(InvalidInputError)
	end

	it "should process the turn instructions properly" do 
		@plateau = Plateau.new 5,5
		@rover = Rover.new 1 ,2, "W", @plateau
		@rover.process_instruction_string("R")
		expect(@rover.current_position).to eq([1,2,"N"])
		@rover.process_instruction_string("R")
		expect(@rover.current_position).to eq([1,2,"E"])
		@rover.process_instruction_string("R")
		expect(@rover.current_position).to eq([1,2,"S"])
		@rover.process_instruction_string("R")
		expect(@rover.current_position).to eq([1,2,"W"])

		@rover.process_instruction_string("L")
		expect(@rover.current_position).to eq([1,2,"S"])
		@rover.process_instruction_string("L")
		expect(@rover.current_position).to eq([1,2,"E"])
		@rover.process_instruction_string("L")
		expect(@rover.current_position).to eq([1,2,"N"])
		@rover.process_instruction_string("L")
		expect(@rover.current_position).to eq([1,2,"W"])
	end 

	it "should process the move instruction properly" do 
		@plateau = Plateau.new 5,5
		@rover = Rover.new 1,2,"W",@plateau
		@rover.process_instruction_string("M")
		
	end

	it "should raise OutOfPlateauRangeError if asked to move beyond the plateau range" do 
		@plateau = Plateau.new 5,5
		@rover = Rover.new 1,2,"W",@plateau
		expect {@rover.process_instruction_string("MM")}.to raise_error(OutOfPlateauRangeError)
		@rover = Rover.new 1,2,"W",@plateau
		expect {@rover.process_instruction_string("RRMMMMMM")}.to raise_error(OutOfPlateauRangeError)
	end

end