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




class Rover
  attr_reader :current_position
  attr_reader :directions
  def initialize(x,y,direction,plateau) # rover needs to have the plateau reference to know the terrain.
    @directions = ["N", "E", "S", "W"]

    raise InvalidInputError if !(plateau.instance_of?(Plateau))

    @plateau = plateau
    #check if the coordinates provided are integers
    begin 
      x,y = Integer(x), Integer(y)
    rescue ArgumentError
      raise InvalidInputError
    end

    
    raise InvalidInputError if !(@directions.include?(direction))
    raise OutOfPlateauRangeError if @plateau.out_of_range?(x,y)
    @current_position = [x,y,direction] 
  end

  private
  def turn(instruction)
    # turns the rover in the given direction, in place.
    current_direction_index = @directions.index(@current_position[2])

    case instruction
    when "L" then
      @current_position.delete_at(2)
      @current_position << @directions[current_direction_index - 1]
    when "R" then
      @current_position.delete_at(2)
      @directions[current_direction_index + 1] ? @current_position << @directions[current_direction_index + 1] : @current_position << @directions[0]
    else raise InvalidInputError
    end
  end

  private
  def move
    # Moves the rover 1 step ahead in the current direction
    current_direction = @current_position[2]
    x,y = @current_position

    case current_direction
    when "N"
      @plateau.out_of_range?(x,y+1) ? (raise OutOfPlateauRangeError) : @current_position[1] += 1
    when "S"
      @plateau.out_of_range?(x,y-1) ? (raise OutOfPlateauRangeError) : @current_position[1] -= 1
    when "E"
      @plateau.out_of_range?(x+1,y) ? (raise OutOfPlateauRangeError) : @current_position[0] += 1
    when "W"
      @plateau.out_of_range?(x-1,y) ? (raise OutOfPlateauRangeError) : @current_position[0] -= 1
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


