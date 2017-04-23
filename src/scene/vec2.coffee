# Public: Vec2
class Fz2D.Vec2
  # Public: Constructor.
  #
  # x - value on the X axis (default: 0)
  # y - value on the Y axis (default: 0)
  constructor: (@x=0, @y=0) ->
    # empty

  # Public: Sets the components of the vector.
  #
  # x - value on the X axis
  # y - value on the Y axis
  set: (x, y) ->
    @x = x
    @y = y

  # Public: Determines the distance to another vector.
  #
  # p - {Fz2D.Vec2}
  # 
  # Returns the distance.
  dist: (p) ->
    dx = @x - p.x
    dy = @y - p.y

    Math.sqrt(dx * dx + dy * dy)

  # Public: Determines the squared distance to another vector.
  #
  # p - {Fz2D.Vec2}
  # 
  # Returns the squared distance.
  distSqr: (p) ->
    dx = @x - p.x
    dy = @y - p.y

    dx * dx + dy * dy

  # Public: Determines the dot product with another vector.
  #
  # p - {Fz2D.Vec2}
  # 
  # Returns the dot product.
  dot: (p) ->
    @x * p.x + @y * p.y

  # Public: Adds another vector to this vector.
  #
  # p - {Fz2D.Vec2}
  #
  # Returns a new {Fz2D.Vec2} with the result.
  add: (p) ->
    new Fz2D.Vec2(@x + p.x, @y + p.y)

  # Public: Subtracts another vector from this vector.
  #
  # p - {Fz2D.Vec2}
  #
  # Returns a new {Fz2D.Vec2} with the result.
  sub: (p) ->
    new Fz2D.Vec2(@x - p.x, @y - p.y)

  # Public: Multiplies vector with a scalar.
  #
  # s - scalar
  #
  # Returns a new {Fz2D.Vec2} with the result.
  mul: (s) ->
    new Fz2D.Vec2(@x * s, @y * s)

  # Public: Divides vector with a scalar.
  #
  # s - scalar
  #
  # Returns a new {Fz2D.Vec2} with the result.
  div: (s) ->
    new Fz2D.Vec2(@x / s, @y / s)

  # Public: Compares vector to another vector.
  # 
  # p - {Fz2D.Vec2}
  #
  # Returns the result of the comparison.
  equals: (p) ->
    @x == p.x and @y == p.y
 
  # Public: Returns true if the vector is null, otherwise false.
  isNull: () ->
    @x == 0 and @y == 0
