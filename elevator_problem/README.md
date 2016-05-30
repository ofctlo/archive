# elevator_problem
let's move some elevators

###Considerations
####Basic Considerations
* What is the closest elevator?
* Is a given elevator moving in the correct direction?
* How large is the queue of requests for a given elevator?

####Other Considerations
* What is the maximum weight allowed on an elevator?
* Bunch riders together in the same elevator to increase efficiency of elevator
  use...
* ...or we could try to give riders their own elevator if possible, if privacy
  is valuable
* We could assign each job to the elevator that would complete the request with
  the shortest disruption to its current plans
* Do we know anything about the usage patterns in the building? (if most rides
  start from floor 1, maybe we send elevators back to floor 1 after they are
  done)

##Elevator Design
Each elevator is responsible for moving itself each step based on some simple
rules. An elevator will start originally moving toward the request it receives.
As long as there remain requests in its queue, it will continue moving,
reversing direction if it reaches the top/bottom, or if there are no more
requests to fulfill in that direction.

Each elevator is also responsible for reasoning about the 'score' of a
potential new request. The dispatcher will assign the job to the elevator that
returns the lowest score.

##Dispatcher Design
determines the 'best elevator' based on the request, hands off request info to
elevator

###`best_elevator`
There are two types of elevators: `ResponseTimeElevator` and
`EfficiencyElevator`.

####`ResponseTimeElevator`
This type scores by looking at how quickly it can fulfill the request in
question. This will result in the person making the request being picked up as
soon as possible.

####`EfficiencyElevator`
This type scores by looking at how much longer it will take to fulfill all
requests with as opposed to without the new request. This will assign the
lowest score to the elevator which can handle the job with the smallest total
addition of elevator labor.

One pretty big source of uncertainty is that when we pick up someone from floor
x we don't know yet what floor they are going to. We could ask which floor
they're going to from the beginning (apparently some elevators do this) but
that's sort of complex for the user. Another approach would be to keep
statistics on which floors people tend to go to from different floors. My guess
is there would be pretty regular patterns. Then we could calculate as if the
person requested the common floor. Or weight the scores for the person
requesting each of the common floors by probability.

##Known Issues
  * Because of how request information is stored on the Elevator class, an
    elevator cannot take 2 jobs for the same floor with different directions.
    The earlier request will be overwritten. This could be fixed relatively
    easily.
  * Since this hasn't really been specced, I'm sure there are other general
    little issues as well...
