require_relative "custom_exceptions"

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