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

	

end