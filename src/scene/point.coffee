# Public: Point
class Fz2D.Point
  # Public: Constructor.
  #
  # x - position on the X axis (default: 0)
  # y - position on the Y axis (default: 0)
  constructor: (@x=0, @y=0) ->
    # empty

  # Public: Sets the components of the point.
  #
  # x - position on the X axis
  # y - position on the Y axis
  set: (x, y) ->
    @x = x
    @y = y
 
  # Public: Compares point to another point.
  # 
  # p - {Fz2D.Point}
  #
  # Returns the result of the comparison.
  equals: (p) ->
    @x == p.x and @y == p.y
 
  # Public: Returns true if the point is null, otherwise false.
  isNull: () ->
    @x == 0 and @y == 0
