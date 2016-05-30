# I'm not really happy with this naming. This thing could represent
# a request, but it could also represent an actual or potential
# position/velocity of an elevator. Haven't thought of a good 
# general name yet though.
Request = Struct.new(:floor, :direction)