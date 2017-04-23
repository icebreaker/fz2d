# Public: BBox
class Fz2D.BBox
  # Public: Constructor
  #
  # x - position on the X axis
  # y - position on the Y axis
  # w - width
  # h - height
  constructor: (@x, @y, @w, @h) ->
    @x ?= 0
    @y ?= 0
    @w ?= 0
    @h ?= 0
    @center = new Fz2D.Vec2()
    @_update()

  # Public: Sets the position and size.
  #
  # x - position on the X axis
  # y - position on the Y axis
  # w - width
  # h - height
  set: (x, y, w, h) ->
    @x = x
    @y = y
    @w = w
    @h = h
    @_update()
  
  # Public: Sets the position of the rectangle.
  #
  # x - position on the X axis
  # y - position on the Y axis
  setPos: (x, y) ->
    @x = x
    @y = y
    @_update()

  # Public: Sets the size of the rectangle.
  #
  # w - width
  # h - height
  setSize: (w, h) ->
    @w = w
    @h = h
    @_update()

  # Public: Determines if a point is inside the rectangle.
  #
  # p - {Fz2D.Vec2}
  #
  # Returns true or false.
  contains: (p) ->
   ((@p.x >= @x) and (@p.x <= @x + @w) and (@p.y >= @y) and (@p.y <= @y + @h))

  # Public: Determines if the rectangle overlaps another rectangle.
  #
  # r - {Fz2D.BBox}
  #
  # Returns true or false.
  overlaps: (r) ->
    !((@x > r.x + r.w) or (@y > r.y + r.h) or (@x + @w < r.x) or (@y + @h < r.y))

  # Public: Compares the rectangle to another rectangle.
  #
  # r - {Fz2D.BBox}
  #
  # Returns the result of the comparison.
  equals: (r) ->
    @x == r.x and @y == r.y and @w == r.w and @h == r.h
 
  # Public: Returns true if the rectangle is null, otherwise false.
  isNull: () ->
    @w == 0 or @h == 0

  # Private: Updates half size and center.
  _update: () ->
    @hw     = @w * 0.5
    @hh     = @h * 0.5
    @radius = @hw
    @center.set(@x + @hw, @y + @hh)
    @
