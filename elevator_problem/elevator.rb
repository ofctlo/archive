require_relative './request.rb'

class Elevator
  MOVE_TIME = 1
  REQUEST_TIME = 3

  attr_accessor :floor, :direction

  def initialize(floor, num_floors, direction = 0, requests = nil)
    raise 'invalid parameters' unless requests.nil? || (num_floors == requests.length)

    @floor = floor
    @direction = direction
    @num_floors = num_floors
    @requests = requests || Array.new(@num_floors) { nil }
  end

  def clone
    Elevator.new(@floor, @num_floors, @direction, @requests)
  end

  # Called once per floor, this takes all appropriate actions
  # for this elevator on the current floor
  def step
    halt if should_halt?
    stop_elevator or move_elevator
  end

  # Adds a new floor to stop at. Called by the dispatcher when adding a new
  # request, and when a rider pushes a button from inside this elevator
  def add_request(request)
    @requests[request.floor] = { direction: request.direction }
    self
  end

  # Permanently stops the elevator until further notice (no jobs)
  def stop_elevator
    return false if stops_remaining?
    @direction = 0 and return true
  end

  # The elevator should only stop if it is on the proper floor
  # and going in the direction of the request
  def should_halt?(request = default_request)
    request_info(request.floor) && direction_matches?(request)
  end

  protected

  def time_till(&block)
    elevator = clone
    count = 0

    loop do
      count += REQUEST_TIME if elevator.should_halt?
      count += MOVE_TIME unless elevator.stop_elevator
      elevator.step

      break if block.call(elevator)
    end

    count
  end

  private

  def move_elevator
    set_initial_direction if @direction == 0

    @direction *= -1 if should_reverse?
    @floor += @direction
  end

  # Represents stopping for a request
  def halt
    open_door
    close_door
  end

  def direction_matches?(request, direction = @direction)
    [0, direction].include? request.direction
  end

  def set_initial_direction
    distance = 1

    until @floor - distance < 0 && @floor + distance >= @requests.length
      request = @requests[@floor - distance] || @requests[@floor + distance]
      next unless request

      if request.floor < @floor
        @direction = -1
      elsif request.floor > @floor
        @direction = 1
      end

      return
    end
  end

  # The elevator continues in the same direction until there are no
  # more stops to make in that direction. The edge case of reaching
  # the top or bottom is implicitly handled by this.
  def should_reverse?
    stops_remaining_in_direction?
  end

  def stops_remaining_in_direction?(floor = @floor, direction = @direction)
    return false if direction == 0

    direction == -1 ?
      stops_remaining?(floor..-1) : stops_remaining?(0..floor)
  end

  def stops_remaining?(range = (0..-1))
    @requests[range].any?
  end

  def request_info(floor = @floor)
    return nil unless info = @requests[floor]
    Request.new(floor, info[:direction])
  end

  def default_request
    Request.new(@floor, @direction)
  end
end
