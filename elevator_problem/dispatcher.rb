require_relative './request.rb'
require_relative './elevator.rb'

class Dispatcher
  # A building array is an array of integers. Each element represents
  # a floor, starting at 1 (0), and the integer values represent how
  # many elevators are on that floor initially.
  def initialize(building_array = Array.new(10))
    @elevators = building_array.map_with_index do |num_elevators, floor|
      num_elevators.times { Elevator.new(floor, building_array.length) }
    end
  end

  # @param request [Request] a floor/direction pair
  def process_request(request)
    best_elevator(request).add_request(request)
  end

  private

  def best_elevator(request)
    elevators_with_scores(request).minimum do |a, b|
      a[:score] <=> b[:score]
    end[:elevator]
  end

  def elevators_with_scores(request)
    @elevators.map do |elevator|
      {
        elevator: elevator,
        score: score(elevator, request)
      }
    end
  end

  # Another way would be to pu the code to score on the Elevator,
  # because then I could use that code in `Elevator#<=>`. This
  # could clean up the code by allowing me to replace all the
  # best_elevator code with `@elevators.minimum`. That would
  # be nice but in the end it made more conceptual sense to have
  # the sorting code on the Dispatcher, since that is where the
  # responsibility for deciding which elevator to dispatch falls.
  def score(elevator, request)
    elevator.new_request_cost(request)
  end
end
