# Public: Rectangle
class Fz2D.Rect
  # Public: Constructor
  #
  # x - position on the X axis
  # y - position on the Y axis
  # w - width
  # h - height
  constructor: (@x=0, @y=0, @w=0, @h=0) ->
    # empty

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
    @
  
  # Public: Sets the position of the rectangle.
  #
  # x - position on the X axis
  # y - position on the Y axis
  setPos: (x, y) ->
    @x = x
    @y = y
    @

  # Public: Sets the size of the rectangle.
  #
  # w - width
  # h - height
  setSize: (w, h) ->
    @w = w
    @h = h
    @

  # Public: Determines if a point is inside the rectangle.
  #
  # p - {Fz2D.Point}
  #
  # Returns true or false.
  contains: (p) ->
   ((@p.x >= @x) and (@p.x <= @x + @w) and (@p.y >= @y) and (@p.y <= @y + @h))

  # Public: Determines if the rectangle overlaps another rectangle.
  #
  # r - {Fz2D.Rect}
  #
  # Returns true or false.
  overlaps: (r) ->
    !((@x > r.x + r.w) or (@y > r.y + r.h) or (@x + @w < r.x) or (@y + @h < r.y))

  # Public: Compares the rectangle to another rectangle.
  #
  # r - {Fz2D.Rect}
  #
  # Returns the result of the comparison.
  equals: (r) ->
    @x == r.x and @y == r.y and @w == r.w and @h == r.h
 
  # Public: Returns true if the rectangle is null, otherwise false.
  isNull: () ->
    @w == 0 or @h == 0
