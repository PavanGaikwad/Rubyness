require_relative "custom_exceptions"
require_relative "rover"
require_relative "plateau"


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