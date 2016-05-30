require_relative './elevator.rb'

# An elevator subclass that scores based on the response time to the new
# request. The best scoring elevator is the one that would fulfill the request
# most quickly.
class ResponseTimeElevator < Elevator
  def time_to_respond(request)
    elevator = clone
    elevator.add_request(request)

    at_request = lambda do |e|
      e.floor == request.floor &&
        (e.direction == request.direction || e.direction == 0)
    end

    elevator.time_till(at_request)
  end
  alias_method score time_to_respond
end
