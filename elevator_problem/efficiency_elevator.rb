require_relative './elevator.rb'

# An elevator subclass that scores based on the cost of adding a new request to
# its queue. This is determined by how much longer it will take for the elevator
# to complete all requests.
class EfficiencyElevator < Elevator
  def new_request_cost(request)
    with_request = clone
    with_request.add_request(request)

    completed = -> (elevator) { elevator.direction == 0 }

    with_response.time_till(completed) - clone.time_till(completed)
  end
  alias_method score new_request_cost
end
