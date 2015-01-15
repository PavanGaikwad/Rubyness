#mars rover problem

# create classes Rover , Plateau and NASAconsole
# add methods turn, move to Rover
# add method out_of_range? to plateau
# check if all works well under right inputs
# start breaking
# add validations
# => plateau creation
# => rover creation
# => instructions
# => plateau range
# can > 1 rover be on the same co-ordinates? This program assumes yes.

class InvalidInputError < RuntimeError
end

class OutOfPlateauRangeError < RuntimeError
end


class Rover
  attr_reader :current_postition
  attr_reader :directions
  def initialize(x,y,direction,plateau) # rover needs to have the plateau reference to know the terrain.
    @current_postition = [x,y,direction] # check if direction is supported and coordinates are ints. Have put this check in the NASAconsole
    @directions = ["N", "E", "S", "W"]
    @plateau = plateau
  end

  private
  def turn(instruction)
    # turns the rover in the given direction, in place.
    current_direction_index = @directions.index(@current_postition[2])

    case instruction
    when "L" then
      @current_postition.delete_at(2)
      @current_postition << @directions[current_direction_index - 1]
    when "R" then
      @current_postition.delete_at(2)
      @directions[current_direction_index + 1] ? @current_postition << @directions[current_direction_index + 1] : @current_postition << @directions[0]
    else raise InvalidInputError
    end
  end

  private
  def move
    # Moves the rover 1 step ahead in the current direction
    current_direction = @current_postition[2]
    x,y = @current_postition

    case current_direction
    when "N"
      @plateau.out_of_range?(x,y+1) ? (raise OutOfPlateauRangeError) : @current_postition[1] += 1
    when "S"
      @plateau.out_of_range?(x,y-1) ? (raise OutOfPlateauRangeError) : @current_postition[1] -= 1
    when "E"
      @plateau.out_of_range?(x+1,y) ? (raise OutOfPlateauRangeError) : @current_postition[0] += 1
    when "W"
      @plateau.out_of_range?(x-1,y) ? (raise OutOfPlateauRangeError) : @current_postition[0] -= 1
    else
      raise InvalidInputError
    end
  end

  public
  def process_instruction_string(instructions)
    # takes in the input from the NASAconsole
    instructions.split(//).each do | instruction |
      case instruction
      when "L", "R" then turn(instruction)
      when "M" then move
      else raise InvalidInputError
      end
    end
  end

end

class Plateau
  attr_reader :upper_limit
  def initialize(upper_x, upper_y)
    #check if inputs are numbers
    begin
      upper_x = Integer(upper_x)
      upper_y = Integer(upper_y)
    rescue ArgumentError
      raise InvalidInputError
    end


    @lower_limit = [0,0]
    @upper_limit = [upper_x, upper_y]

  end

  def out_of_range?(x,y)
    x > @upper_limit[0] || y > @upper_limit[1] || x < 0 || y < 0
  end
end

class NASAconsole
  #create plateau
  #position rovers on the plateau
  #start taking in the instructions
  #exceptions need to be handled

  #assuming console has some knowledge about the rovers
  def initialize
    @valid_instructions = ["R","L","M"]
    @valid_directions = ["E","W","N","S"]  # how can we get this from the rover?
    @rovers = []
  end
  def start_mission

    while true
      puts "Create the plateau.. Give me your upper limit co-ordinates, 'space' seperated x y"
      limit_x, limit_y  = gets.chomp.split(" ")
      begin
        limit_x, limit_y = Integer(limit_x), Integer(limit_y)
        plateau = Plateau.new(limit_x, limit_y)
      rescue TypeError, ArgumentError
        puts "Invalid Input try again."
        next
      rescue InvalidInputError
        puts "Invalid Input try again."
        next
      end
      break
    end


    puts "Creating your plateau..."
    puts "Plateau created!!"

    while true
      puts "How many rovers?"
      begin
        number_of_rovers = Integer(gets.chomp)
      rescue ArgumentError
        puts "Punch in a number, nothing else is going to work!"
        next
      end
      if number_of_rovers > 0
        break
      else
        puts "You need more rovers than that!! Punch in a positive number."
      end
    end

    #cant do number_of_rovers.times because, user might create invalid rover leading to re-loop
    # so loop till number_of_time == actual rovers created
    while true do
        puts "Creating a Rover.. Provide position x y direction"
        x_cord , y_cord , direction = gets.chomp.split(" ")

        unless @valid_directions.include?(direction)
          puts "Invalid direction. Try again."
          next
        end
        begin
          x_cord, y_cord = Integer(x_cord), Integer(y_cord)

          if plateau.out_of_range?(x_cord, y_cord)
            puts "Your co-ordinates are out of the Plateau range, Enter something within #{plateau.upper_limit}"
            next
          end
          @rovers << Rover.new(x_cord, y_cord, direction,plateau)
        rescue ArgumentError
          puts "Looks like you didn't enter an Integer for position."
        end
        puts "Created #{@rovers.size} rovers!"

        break if @rovers.size == number_of_rovers
      end

      while(true)
        @rovers.each_with_index do |rover, index|
          puts "Rover #{index} positioned at  #{rover.current_postition}. Waiting for instruction..."
          instruction = gets.chomp
          instruction_array = instruction.split(//)
          if (instruction_array - @valid_instructions) != []
            puts "Detected invalid input. Cancelling. Try Again.."
            next
          end
          begin
            rover.process_instruction_string(instruction)
          rescue OutOfPlateauRangeError
            puts "Looks like your rover is at the edge of the plateau, cannot move further."
          end

          puts rover.current_postition.to_s
        end
      end

    end


  end

  n = NASAconsole.new

  n.start_mission
